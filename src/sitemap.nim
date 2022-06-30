import httpclient, parsexml, streams, strformat, strutils, os

proc getFileName(url: string): string =
  let split = url.split('/')
  result = split[split.high]

proc getFileExt(file: string): string =
  let split = file.split('.')
  result = split[split.high]

proc fetchSitemap*(url: string): string = 
  let 
    client = newHttpClient()
    file = getFileName(url)
  downloadFile(client, url, file)
  let fileExt = getFileExt(file)
  case fileExt
  of "xml": return file
  of "gz":
    let status = execShellCmd("gunzip " & file)
    if status != 0: quit("unzipping failed")
    return file[0 .. ^4] # remove file ext
  else: quit("unknown extension " & fileExt)

proc importSitemap*(file: string): seq[string] =
  var s = newFileStream(file, fmRead)
  if s == nil: quit("cannot open the file " & file)
  var x: XmlParser
  open(x, s, file)
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

proc fetchArticle*(baseurl, article: string): string =
  let 
    client = newHttpClient()
    url = fmt"{baseurl}/Special:Export/{article}"
    file = article & ".xml"
  downloadFile(client, url, file)
  return file
