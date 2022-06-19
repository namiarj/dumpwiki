import parsecfg, strformat, os
import procs

let cfg = loadConfig("config.ini")
let sitemap = cfg.getSectionvalue("mediawiki", "sitemap")
let baseurl = cfg.getSectionvalue("mediawiki", "baseurl")

var file = downloadSitemap(sitemap)
let articles = importSitemap(file)
removeFile(file)

var counter = 1
for article in articles:
  echo(fmt"{counter}/{articles.len} {article}")
  file = downloadArticle(baseurl, article)
  counter.inc
