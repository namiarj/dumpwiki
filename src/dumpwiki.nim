import parsecfg, strformat, os
import procs

let 
  cfg = loadConfig("config.ini")
  sitemap = cfg.getSectionvalue("mediawiki", "sitemap")
  baseurl = cfg.getSectionvalue("mediawiki", "baseurl")

var file = fetchSitemap(sitemap)
let articles = importSitemap(file)
removeFile(file)

var counter = 1
for article in articles:
  echo(fmt"{counter}/{articles.len} {article}")
  file = fetchArticle(baseurl, article)
  counter.inc
