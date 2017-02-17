#!/bin/python
#encoding = utf-8

import urllib2, socket
import sys, re


try:
    import requests
except:
    print "Os componentes necessarios nao foram encontradas. Instale para seguir adiante\n"
    sys.exit()

wordlist = sys.argv[1]
socket.setdefaulttimeout(5)
sys.tracebacklimit = 0

print "\n################################################"
print "#     _              _     _                   #"
print "#    | | ___   ___  | |   (_)_ __  _   ___  __ #"
print "# _  | |/ _ \ / _ \ | |   | | '_ \| | | \ \/ / #"
print "#| |_| | (_) |  __/ | |___| | | | | |_| |>  <  #"
print "# \___/ \___/ \___| |_____|_|_| |_|\__,_/_/\_\ #"
print "#                                              #"
print "# Desenvolvido por Joseph Linux                #"
print "# Proxy Alive Checker                          #"
print "# www.telegram.me/linuxteambr - TLB Sec        #"
print "################################################\n\n"

print '------------------------------------------------'
print 'Uso: python proxy.py <proxylist.txt>'
print 'Formado IP:PORTA'
print 'Proxy Alive Checker'
print '------------------------------------------------'

# ler lista de proxys



proxyList = open(wordlist, 'r').readlines()

print "**Lendo Proxys**"
print "....."

len(proxyList)
            
def is_bad_proxy(pip):    
    try:        
        proxy_handler = urllib2.ProxyHandler({'http': pip})        
        opener = urllib2.build_opener(proxy_handler)
        opener.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.6) Gecko/2009022111 Gentoo Firefox/3.0.6')]
        urllib2.install_opener(opener)        
        req=urllib2.Request('http://createssh.com')
        sock=urllib2.urlopen(req)
    except urllib2.HTTPError, e:        
             return e.code
    except Exception:
             return 1

for item in proxyList:
    if is_bad_proxy(item):
	print "#ProxyChecker JoeLinux :(", item
    else:
        print "#ProxyChecker JoeLinux :D", item


