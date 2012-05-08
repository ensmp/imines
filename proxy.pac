//
// Genere le : Wed Feb  2 09:25:13 CET 2011
//

var YesDomains = new Array(
	".ensmp.fr",
	".mines-paristech.fr",
	".alize",
	".cairn.info",
	".sciencedirect.com",
	".scopus.com",
	".springerlink.com",
	"springerlink.com",
	".isiknowledge.com",
	".onlinelibrary.wiley.com",
	"onlinelibrary.wiley.com",
	".ebscohost.com",
	".acm.org",
	".acs.org",
	".asmedl.org",
	".ieee.org",
	".engineeringvillage.com",
	".iop.org",
	".techniques-ingenieur.fr",
	".universalis-edu.com",
	".britannica.com",
	".lexisnexis.com",
	"");

//

var NoDomains = new Array(
	"www.ensmp.fr",
	"www.mines-paristech.fr",
	"listes.ensmp.fr",
	"listes.mines-paristech.fr",
	"wpad.ensmp.fr",
	"wpad.mines-paristech.fr",
	"www.ccsi.ensmp.fr",
	"www.ccsi.mines-paristech.fr",
	"auth.ensmp.fr",
	"auth.mines-paristech.fr",
	"");

//
//
//
function FindProxyForURL(url, host)
{
  for (i = 0; NoDomains[i] != ""; i++) {
    if (dnsDomainIs(host, NoDomains[i]))
      return "DIRECT";
  }
  for (i = 0; YesDomains[i] != ""; i++) {
    if (dnsDomainIs(host, YesDomains[i]))
      return "PROXY proxy-ext.ensmp.fr:8080";
  }
  return "DIRECT";
}

