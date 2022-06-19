import parsecfg, procs, os

let cfg = loadConfig("config.ini")
let sitemap = cfg.getSectionvalue("mediawiki", "sitemap")
let baseurl = cfg.getSectionvalue("mediawiki", "baseurl")

var file = downloadSitemap(sitemap)
let articles = importSitemap(file)
removeFile(file)

for article in articles:
  file = downloadArticle(article, baseurl)
