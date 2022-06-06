import httpclient, strutils, os

proc getFileExt(filePath: string): string =
  let strSplit = filePath.split('.')
  result = strSplit[strSplit.high]

proc getFileName(url: string): string =
  let pathSplit = url.split('/')
  result = pathSplit[pathSplit.high]

proc downloadSitemap*(url: string): string = 
  let client = newHttpClient()
  let localFile = getFileName(url)
  downloadFile(client, url, localFile)
  
  let fileExt = getFileExt(localFile)
  case fileExt
  of "xml":
    return localFile
  of "gz":
    echo("unzipping")
    let status = execShellCmd("gunzip $1" % [localFile])
    if status != 0: quit("unzipping failed")
    return localFile[.. ^4] # remove file ext
  else: quit("unknown extension $1" % [fileExt])


