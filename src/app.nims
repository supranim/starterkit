when defined(macosx):
  --passL:"/usr/local/lib/libmonocypher.a"
  --passC:"-I /opt/local/include"
  --passC:"-I /usr/local/include"
  --passC:"-Wno-incompatible-function-pointer-types"
elif defined(linux):
  --passL:"-L/usr/local/lib/lib -L/usr/local/lib -Wl,-rpath,/usr/local/lib/lib -Wl,-rpath,/usr/local/lib -lmonocypher"
  --passC:"-I /usr/include"

--deepCopy:on
--mm:atomicArc
--define:webapp
--define:ssl
--define:supraFileserver
--define:supraNative # using pkg/powpow backend

when not defined release:
  --define:timHotCode
  # Embed assets in production for better performance and easier deployment
  const embedAssetsPath {.strdefine.} = ""
  when defined supraEmbedAssets:
    let outputEmbedAssets = getProjectPath().parentDir() / ".cache" / "embed_assets.nim"
    let assetsPath = absolutePath(joinPath(getProjectPath() / "storage", "assets"))
    if dirExists(assetsPath):
      exec "supra bundle.assets \"" & assetsPath & "\" \"" & outputEmbedAssets & "\""