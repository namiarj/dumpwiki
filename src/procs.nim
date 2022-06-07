import httpclient, parsexml, streams, strutils, os

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
    echo("unzipping " & localFile)
    let status = execShellCmd("gunzip $1" % [localFile])
    if status != 0: quit("unzipping failed")
    return localFile[0 .. ^4] # remove file ext
  else: quit("unknown extension $1" % [fileExt])

proc importSitemap*(filename: string): seq[string] =
  var s = newFileStream(filename, fmRead)
  if s == nil: quit("cannot open the file " & filename)
  var x: XmlParser
  open(x, s, filename)
  var articles: seq[string]
  while true:
    x.next()
    case x.kind
    of xmlElementStart:
      if cmpIgnoreCase(x.elementName, "loc") == 0:
        var loc = ""
        x.next()
        while x.kind == xmlCharData:
          loc.add(x.charData)
          x.next()
        if x.kind == xmlElementEnd and cmpIgnoreCase(x.elementName, "loc") == 0:
          let article = getFileName(loc)
          articles.add(article)
        else:
          echo(x.errorMsgExpected("/loc"))
  
    of xmlEof: break # end of file reached
    else: discard
  return articles

proc downloadArticles*(articles: seq[string], baseurl: string) =
  for article in articles:
    let client = newHttpClient()
    let url = "$1/Special:Export/$2" % [baseurl, article]
    let localFile = article & ".xml"
    echo("downloading " & url)
    downloadFile(client, url, localFile)
