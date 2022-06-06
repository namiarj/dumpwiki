import parsecfg, procs

let cfg = loadConfig("config.ini")
let sitemap = cfg.getSectionvalue("mediawiki", "sitemap")

let file = downloadSitemap(sitemap)
