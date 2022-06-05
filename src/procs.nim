import httpclient, strutils, os

proc downloadSitemap*(url: string) = 
  let client = newHttpClient()
  let localFile = getUrlPath(url)
  downloadFile(client, url, localFile)
  
  case fileExt = getFileExt(localFile)
  of "xml":
    echo("")
  of "gz":
    echo("unzipping")
    let status = execShellCmd("gunzip $1" % [localFile])
    if status != 0: quit("unzipping failed")
  else: quit("unknown extension $1" % [fileExt])


proc getFileExt(filePath: string): string =
  let extSplit = filePath.split('.')
  result = extSplit[extSplit.high]

proc getUrlPath(url: string): string =
  let pathSplit = url.split('/')
  result = pathSplit[pathSplit.high]
