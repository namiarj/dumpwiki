import parsecfg, procs, os

let cfg = loadConfig("config.ini")
let sitemap = cfg.getSectionvalue("mediawiki", "sitemap")
let baseurl = cfg.getSectionvalue("mediawiki", "baseurl")

let file = downloadSitemap(sitemap)
scrapeSitemap(file, baseurl)
