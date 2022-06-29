import parsecfg, strformat, os
import procs

const cfg_default = "config.ini"

let 
  cfg = loadConfig(cfg_default)
  sitemap = cfg.getSectionvalue("mediawiki", "sitemap")
  baseurl = cfg.getSectionvalue("mediawiki", "baseurl")

var file = fetchSitemap(sitemap)
let articles = importSitemap(file)
removeFile(file)

var counter = 0 
var skip = ' '
for article in articles:
  block jump:
    counter.inc
    if fileExists(article & ".xml"):
      case skip
      of ' ':
        echo(fmt"The file {article}.xml already exists")
        echo("Skip? a (all)/n (none)/o (once)")
        skip = stdin.readChar()
      of 'a': break jump 
      of 'n': discard
      of 'o':
        skip = ' '
        break jump
      else: skip = ' '
    echo(fmt"{counter}/{articles.len} {article}")
    try:
      file = fetchArticle(baseurl, article)
    except:
      quit(fmt"error fetching {article}")
