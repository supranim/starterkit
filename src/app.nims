when defined(macosx):
  --passL:"/opt/local/lib/libssl.a"
  --passL:"/opt/local/lib/libcrypto.a"
  --passL:"/usr/local/lib/libmonocypher.a"
  # --passL:"/usr/local/lib/libevent.a"
  # --passL:"/usr/local/lib/libevent_pthreads.a"
  --passC:"-I /opt/local/include"
  --passC:"-I /usr/local/include"
  # --passC:"-I /usr/local/include/event2"
elif defined(linux):
  --passL:"/usr/local/lib/libssl.so"
  --passL:"/usr/local/lib/libcrypto.so"
  --passL:"/usr/local/lib/libssl.so"
  --passC:"-I /usr/local/include"

--deepCopy:on
--mm:atomicArc
--define:webapp
--define:ssl
--define:supraFileserver
--define:supraNative # using pkg/powpow backend

when not defined release:
  --define:timHotCode
else:
  --passC:"-O3 -flto" # Optimize for speed
  --passL:"-flto"     # Link Time Optimization for smaller/faster binaries

  # Embed assets in production for better performance and easier deployment
  const embedAssetsPath {.strdefine.} = ""
  when defined supraEmbedAssets:
    let outputEmbedAssets = getProjectPath().parentDir() / ".cache" / "embed_assets.nim"
    let assetsPath = absolutePath(joinPath(getProjectPath() / "storage", "assets"))
    if dirExists(assetsPath):
      exec "supra bundle.assets \"" & assetsPath & "\" \"" & outputEmbedAssets & "\""