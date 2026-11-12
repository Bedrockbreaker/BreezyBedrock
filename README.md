# BreezyBedrock

Mostly just a personal repository for some customizations.

Feel free to poke around or what have you.

Icons are largely derivative of the existing ones found in [Breeze Icons](https://invent.kde.org/frameworks/breeze-icons), so their same license applies here.

---

## Installation

Run `install.sh --install`. To uninstall, use the `--uninstall` flag: `./install.sh --uninstall`

---

## Features (local-only, not system-wide)

Adds the following mimetypes:
- text/x-typescript (*.ts, *.tsx)
- text/x-astro (*.astro)
- application/x-unity-scene (*.unity)
- application/x-unity-prefab (*.prefab)
- application/x-unity-asset
	- *.anim
	- *.asmdef
	- *.asmref
	- *.asset
	- *.blendtree
	- *.brush
	- *.buildreport
	- *.cginc
	- *.colors
	- *.compute
	- *.controller
	- *.cubemap
	- *.curves
	- *.curvesNormalized
	- *.flare
	- *.fontsettings
	- *.giparams
	- *.gradients
	- *.guiskin
	- *.ht
	- *.inputactions
	- *.jslib
	- *.jspre
	- *.mask
	- *.mat
	- *.mesh
	- *.mixer
	- *.overrideController
	- *.particleCurves
	- *.particleCurvesSigned
	- *.particleDoubleCurves
	- *.particleDoubleCurvesSigned
	- *.physicMaterial
	- *.physicsMaterial2D
	- *.playable
	- *.preset
	- *.raytrace
	- *.renderTexture
	- *.rsp
	- *.shader
	- *.shadergraph
	- *.shadersubgraph
	- *.shadervariants
	- *.signal
	- *.spriteatlas
	- *.state
	- *.statemachine
	- *.terrainlayer
	- *.texture2D
	- *.transition
	- *.uss
	- *.uxml
	- *.vfx
	- *.vfxblock
	- *.vfxoperator
	- *.webCamTexture
- application/x-unity-meta
	- magic:
		- "fileFormatVersion: 2" (offset 0)
		- "fileFormatVersion: 3" (offset 0)

Adds globs for the existing mimetypes:
- text/markdown (*.mdx)

Adds icons for the following mimetypes:
- application-x-code-workspace (application/x-code-workspace)
- text-x-typescript (text/x-typescript)
- text-x-astro (text/x-astro)
- application-x-unity-scene (application/x-unity-scene)
- application-x-unity-prefab (application/x-unity-prefab)
- application-x-unity-asset (application/x-unity-asset)
- application-x-unity-meta (application/x-unity-meta)
