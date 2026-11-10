
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

ICON_SOURCE="$SCRIPT_DIR/icons/BreezyBedrock"
ICON_DEST="$DATA_HOME/icons/BreezyBedrock"

MIME_DIR="$DATA_HOME/mime"
MIME_DEST="$MIME_DIR/packages/Override.xml"

ACTION="${1:---install}"

usage() {
    echo "Usage: $0 [--install|--uninstall]" >&2
    exit 1
}

[[ "$ACTION" == "--install" || "$ACTION" == "--uninstall" ]] || usage

for dependency in python3 update-mime-database; do
    command -v "$dependency" >/dev/null 2>&1 || {
        echo "Missing dependency: $dependency" >&2
        exit 1
    }
done

manage_mime() {
    ACTION="${ACTION#--}"
    export ACTION DATA_HOME

    python3 <<'PY'
import os
import xml.etree.ElementTree as ET
from pathlib import Path

NS = "http://www.freedesktop.org/standards/shared-mime-info"
ET.register_namespace("", NS)

BEGIN = "BREEZYBEDROCK MANAGED BEGIN"
END = "BREEZYBEDROCK MANAGED END"

mime_dir = Path(os.environ["DATA_HOME"]) / "mime"
packages_dir = mime_dir / "packages"
override_file = packages_dir / "Override.xml"

def tag(name):
    return f"{{{NS}}}{name}"

def find_mime(root, mime_type):
    for node in root.findall(tag("mime-type")):
        if node.get("type") == mime_type:
            return node
    return None

def remove_managed_entries(node):
    inside = False

    for child in list(node):
        if child.tag is ET.Comment:
            if child.text == BEGIN:
                inside = True
                node.remove(child)
                continue

            if child.text == END:
                inside = False
                node.remove(child)
                continue

        if inside:
            node.remove(child)

def add_managed_entries(node, entries):
    node.append(ET.Comment(BEGIN))

    for element, attributes, text in entries:
        child = ET.SubElement(node, tag(element), attributes)

        if text:
            child.text = text

    node.append(ET.Comment(END))

definitions = {
    "application/x-code-workspace": [
        ("icon", {"name": "application-x-code-workspace"}, None),
    ],

    "text/x-typescript": [
        ("comment", {}, "TypeScript source code"),
        ("glob", {"pattern": "*.ts", "weight": "90"}, None),
        ("glob", {"pattern": "*.tsx", "weight": "90"}, None),
        ("icon", {"name": "text-x-typescript"}, None),
    ],

    "text/x-astro": [
        ("comment", {}, "Astro component"),
        ("glob", {"pattern": "*.astro", "weight": "90"}, None),
        ("icon", {"name": "text-x-astro"}, None),
    ],

	"text/markdown": [
		("glob", {"pattern": "*.mdx", "weight": "90"}, None),
	],
}

if override_file.exists():
    parser = ET.XMLParser(
        target=ET.TreeBuilder(insert_comments=True)
    )
    tree = ET.parse(override_file, parser=parser)
    root = tree.getroot()
else:
    root = ET.Element(tag("mime-info"))
    tree = ET.ElementTree(root)

if root.tag != tag("mime-info"):
    raise RuntimeError("Unexpected MIME database root element")

for mime_type, entries in definitions.items():
    node = find_mime(root, mime_type)

    if node is None:
        if os.environ["ACTION"] == "uninstall":
            continue

        node = ET.SubElement(
            root,
            tag("mime-type"),
            {"type": mime_type}
        )

    # Remove our previous entries before installing updated ones.
    remove_managed_entries(node)

    if os.environ["ACTION"] == "install":
        add_managed_entries(node, entries)

    # Remove MIME declarations that are now completely empty.
    elif not list(node) and not (node.text or "").strip():
        root.remove(node)

if os.environ["ACTION"] == "uninstall":
    # Remove the file only if no other MIME definitions remain.
    if not list(root) and not (root.text or "").strip():
        override_file.unlink(missing_ok=True)

        # Remove the packages directory only if it is empty.
        try:
            packages_dir.rmdir()
        except OSError:
            pass

        print("Removed BreezyBedrock MIME customizations.")
        raise SystemExit(0)

if os.environ["ACTION"] == "install":
    packages_dir.mkdir(parents=True, exist_ok=True)

    override_file.write_bytes(
        ET.tostring(
            root,
            encoding="UTF-8",
            xml_declaration=True
        )
    )

    print(f"Updated {override_file}")
PY
}

uninstall() {
    echo "Removing BreezyBedrock..."

    rm -rf -- "$ICON_DEST"

    manage_mime
    update-mime-database "$MIME_DIR"

    echo "Uninstallation complete."
}

install_theme() {
    echo "Installing BreezyBedrock..."

    if [[ ! -d "$ICON_SOURCE" ]]; then
        echo "Icon theme source not found: $ICON_SOURCE" >&2
        exit 1
    fi

    mkdir -p "$ICON_DEST"
    cp -a "$ICON_SOURCE/." "$ICON_DEST/"

    manage_mime
    update-mime-database "$MIME_DIR"

    echo "Installation complete."
    echo "Select BreezyBedrock in KDE System Settings > Icons."
}

case "$ACTION" in
    --install)
        install_theme
        ;;
    --uninstall)
        uninstall
        ;;
esac
