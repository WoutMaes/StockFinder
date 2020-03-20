# StockFinder
Search public traded companies based on their logo's.


Mijn app gaat via de API van Alpha Vantage op zoek naar het aandeel dat je opzoekt door  

- ofwel gebruik te maken van de stockscreener (gewoon zoekstring ingeven bijvoorbeeld: 
  Apple en dan toont mijn app de aandelentickers van de aandelen die overeenkomen met de zoekstring: 
  voor Apple is de aandelenticker AAPL, maar ook de andere afgeleide producten van apple die je op de 
  beurs kan kopen bijvoorbeeld APLE, dit is Apple Hospitality REIT , Dit is een beursgenoteerd vastgoedbedrijf. ) 
  Als je dan op één van die bedrijven klikt krijg je de aandeleninformatie te zien (openingskoers, hoogste en laagste koers …)

-	ofwel gebruik te maken van image recognition via Take Picture.
  Ik heb mijn imagerecognition getraint op logo’s van enkele bedrijven. 
  Als je een foto neemt van een logo, dan krijg je via de WikipediaAPI informatie over het bedrijf. 
  Als je op de foto klikt boven die informatie, dan krijg je ook weer de aandeleninformatie van dat bedrijf.

Van deze bedrijven kan mijn app de logo’s herkennen (je mag wel enkel op het logo inzoomen, ik heb het maar met 30 foto’s per bedrijf getraint 😛 ) :
1.	Adidas
2.	Apple
3.	Basic Fit
4.	Coca cola
5.	Dorito’s (geen beursgenoteerd aandeel, dus zal geen aandeleninformatie geven.)
6.	Luftansa
7.	Ferrari
8.	Ford
9.	HP
10.	Lays (Weer geen beursgenoteerd aandeel, blijkbaar had ik honger 😛 )
11.	Mcdonald’s
12.	Nike
13.	Paypal
14.	Pepsi
15.	Puma
16.	RyanAir
17.	Tesla
18.	TUI
19.	Twitter
20.	Under Armour
21.	Volkswagen
22.	Volvo
23.	Wendys
