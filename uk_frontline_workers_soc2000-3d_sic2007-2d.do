

** Approximates a category of 'frontline worker (in essentail work)' based on UK SOC 2000 3-digit plus SIC-2007 2-digit codes 



** Influenced by UK govt definition of 'critical workers' at 
**  https://www.gov.uk/government/publications/coronavirus-covid-19-maintaining-educational-provision/guidance-for-schools-colleges-and-local-authorities-on-maintaining-educational-provision



** Paul Lambert, University of Stirling
**  Version of: 13/Jun/2020



** Assumes 'outvar' is a name for a new dummy variable that will indicate frontline worker status, 
**   'invar1' is UK SOC2000 at 3-digit level, and 'invar2' is UK SIC2007 at 2-digit level 


capture drop $outvar 

gen $outvar=0 if ///
    $invar1 >= 111 & $invar1 <= 925 & $invar2 >= 1 & $invar2 <=  99 /* valid range for soc 3-dig and sic 2-dig */






******************************************

*** Codes that assign to 'critical worker' on presumption that occ and/or industry imply that: 

**
** Health and social care 
*(includes any in industry and occupation)
replace $outvar=1 if $invar1==118 
replace $outvar=1 if $invar1==221 
replace $outvar=1 if $invar1==321 
replace $outvar=1 if $invar1==322 
replace $outvar=1 if $invar1==323 
replace $outvar=1 if $invar1==611 
*
replace $outvar=1 if $invar2==21 
replace $outvar=1 if $invar2==86 
replace $outvar=1 if $invar2==87
replace $outvar=1 if $invar2==88  
**


**
**Education and childcare 
*(all childcare but only includes some occs from education)
replace $outvar=1 if $invar2==85 & ///
   ($invar1==118 | $invar1==231 | $invar1==323 | $invar1==411 | $invar1==421 | $invar1==921 | $invar1==923 | $invar1==924)
replace $outvar=1 if $invar1==612
**


**
**Key public services
* (only able to isolate some of the categories) 
* (includes broadcasters but only those providing public service broadcasting - these can't be isolated)
replace $outvar=1 if $invar1==244
replace $outvar=1 if $invar1==629  
**


**
**Local and national government
* ("This only includes: those administrative occupations essential to the effective delivery of the COVID-19 response
*   or delivering essential public services, such as the payment of benefits, including in government
*   agencies and arms length bodies") 
replace $outvar=1 if ($invar2==36 | $invar2==37 | $invar2==38 | $invar2==84 | $invar2==85 | $invar2==86 | $invar2==87 | $invar2==88) & /// 
       ( $invar1==111 | $invar1==411 | $invar1==244    ) 
**




**
**Food and other necessary goods
* (..production, processing, distribution, sale, delivery, hygene, vetinary..)
* below, go with industries that seem mainly in this area, and likewise occs 
replace $outvar=1 if $invar2==1
replace $outvar=1 if $invar2==3
replace $outvar=1 if $invar2==10
replace $outvar=1 if $invar2==11
replace $outvar=1 if $invar2==75
*
replace $outvar=1 if $invar1==121
replace $outvar=1 if $invar1==511
replace $outvar=1 if $invar1==543
replace $outvar=1 if $invar1==613
*
replace $outvar=1 if $invar2==56 & $invar1==821 /* food delivery drivers specifically */
*
**


**
**Public safety and national security
replace $outvar=1 if $invar1==117 
replace $outvar=1 if $invar1==331 
replace $outvar=1 if $invar1==924 
*
replace $outvar=1 if $invar2==80 
**


**
**Transport
replace $outvar=1 if ($invar2==49 | $invar2==50 | $invar2==51 | $invar2==52 | $invar2==53)
replace $outvar=1 if $invar1==351
replace $outvar=1 if $invar1==821 & ($invar2==46 | $invar2==47 )
**

**
**Utilities, communication and financial services
* (many categories seem quite ambiguous given the definition)
replace $outvar=1 if $invar2==6
replace $outvar=1 if $invar2==35
replace $outvar=1 if $invar2==36
replace $outvar=1 if $invar2==37
replace $outvar=1 if $invar2==38
replace $outvar=1 if $invar2==39
replace $outvar=1 if $invar2==61
replace $outvar=1 if $invar2==63
replace $outvar=1 if $invar2==64
replace $outvar=1 if $invar2==84

replace $outvar=1 if $invar1==115
replace $outvar=1 if $invar1==213
replace $outvar=1 if $invar1==242
replace $outvar=1 if $invar1==313
replace $outvar=1 if $invar1==412
replace $outvar=1 if $invar1==524
**

******************************************







******************************************

**** Post-hoc corrections on 'critical workers': adjustments to remove 'false positives' by inspection
*    (i.e. occ+industry combinations that don't seem plausible)

replace $outvar=0 if ($invar2==10 | $invar2==11) ///
     & ($invar1==111 | $invar1==113 | $invar1==813) 
replace $outvar=0 if ($invar2==35) & ($invar1==113 ) 
replace $outvar=0 if $invar1==412 & ($invar2 >= 41 & $invar2 <= 47) 
replace $outvar=0 if $invar1==524 & $invar2==43
replace $outvar=0 if $invar2==52 & ($invar1 >= 113 & $invar1 <= 813) 
replace $outvar=0 if $invar1==113 & ($invar2==61 | $invar2==64) 
replace $outvar=0 if $invar1==242 & $invar2==70 
replace $outvar=0 if $invar1==412 & ($invar2==71 | $invar2==79)
replace $outvar=0 if $invar1==113 & $invar2==88 
replace $outvar=0 if ($invar2==91 | $invar2==92 | $invar2==93 | $invar2==96) 

******************************************





***********************************************
** Frontline worker adjustment (i): code that removes occupations (or occ+industry combinations) previously coded 'critical' 
*     that are unlikely to have a frontline component 

* (Typically, excludes likely non-frontline (usually non-manual) occs except those in health sector)

replace $outvar=0 if $invar1==111 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==112 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==113 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==114 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==115 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==116 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==211 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==212 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==213 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==232 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==241 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==242 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==243 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==244 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==245 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==311 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==312 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==313 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==341 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==342 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==343 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==344 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==352 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==353 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==354 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==355 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==356 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==411 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==412 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==413 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==414 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==415 & ($invar2~=86 & $invar2~=87) 
replace $outvar=0 if $invar1==421 & ($invar2~=86 & $invar2~=87) 



***********************************************





***********************************************
** Frontline worker adjustment (ii): code that adds occupations not hitherto coded as 'critical workers' 
*    that are likely to have a significant 'frontline' component in Coronavirus era  

***********************************************

**
replace $outvar=1 if $invar1==244
replace $outvar=1 if $invar1==331
replace $outvar=1 if $invar1==351
replace $outvar=1 if $invar1==711 & ($invar2==47 | $invar2==56)
replace $outvar=1 if $invar1==821
replace $outvar=1 if ($invar1==922 | $invar1==923) &  ///
     (($invar2>=45 & $invar2 <=66) | ($invar2==75 | $invar2==77 | $invar2==78 | $invar2==80 | $invar2==81) )
**

******************************************





******************************************

** Missing data recode (force the code missing if either industry or occ is missing): 
replace $outvar=.m if (($invar1 >= 111 & $invar1 <= 925 & $invar2 >= 1 & $invar2 <=  99)==0)

******************************************



** [END OF CODING]





************************************************************************
************************************************************************



/*

** UK SIC 2007 2-digit categories: 

    1   1. Crop and animal production, hunting and related service activities
           2   2. Forestry and logging
           3   3. Fishing and aquaculture
           5   5. Mining of coal and lignite
           6   6. Extraction of crude petroleum and natural gas
           7   7. Mining of metal ores
           8   8. Other mining and quarrying
           9   9. Mining support service activities
          10   10. Manufacture of food products
          11   11. Manufacture of beverages
          12   12. Manufacture of tobacco products
          13   13. Manufacture of textiles
          14   14. Manufacture of wearing apparel
          15   15. Manufacture of leather and related products
          16   16. Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles
               of straw and plaiting ma
          17   17. Manufacture of paper and paper products
          18   18. Printing and reproduction of recorded media
          19   19. Manufacture of coke and refined petroleum products
          20   20. Manufacture of chemicals and chemical products
          21   21. Manufacture of basic pharmaceutical products and pharmaceutical preparations
          22   22. Manufacture of rubber and pLastic products
          23   23. Manufacture of other non-metallic mineral products
          24   24. Manufacture of basic metals
          25   25. Manufacture of fabricated metal products, except machinery and equipment
          26   26. Manufacture of computer, electronic and optical products
          27   27. Manufacture of electrical equipment
          28   28. Manufacture of machinery and equipment n.e.c.
          29   29. Manufacture of motor vehicles, trailers and semi-trailers
          30   30. Manufacture of other transport equipment
          31   31. Manufacture of furniture
          32   32. Other manufacturing
          33   33. Repair and installation of machinery and equipment
          35   35. Electricity, gas, steam and air conditioning supply
          36   36. Water collection, treatment and supply
          37   37. Sewerage
          38   38. Waste collection, treatment and disposal activities; materials recovery
          39   39. Remediation activities and other waste management services.
          41   41. Construction of buildings
          42   42. Civil engineering
          43   43. Specialised construction activities
          45   45. Wholesale and retail trade and repair of motor vehicles and motorcycles
          46   46. Wholesale trade, except of motor vehicles and motorcycles
          47   47. Retail trade, except of motor vehicles and motorcycles
          49   49. Land transport and transport via pipelines
          50   50. Water transport
          51   51. Air transport
          52   52. Warehousing and support activities for transportation
          53   53. Postal and courier activities
          55   55. Accommodation
          56   56. Food and beverage service activities
          58   58. Publishing activities
          59   59. Motion picture, video and television programme production, sound recording and music publishing
               activities
          60   60. Programming and broadcasting activities
          61   61. Telecommunications
          62   62. Computer programming, consultancy and related activities
          63   63. Information service activities
          64   64. Financial service activities, except insurance and pension funding
          65   65. Insurance, reinsurance and pension funding, except compulsory social security
          66   66. Activities auxiliary to financial services and insurance activities
          68   68. Real estate activities
          69   69. Legal and accounting activities
          70   70. Activities of head offices; management consultancy activities
          71   71. Architectural and engineering activities; technical testing and analysis
          72   72. Scientific research and development
          73   73. Advertising and market research
          74   74. Other professional, scientific and technical activities
          75   75. Veterinary activities
          77   77. Rental and leasing activities
          78   78. Employment activities
          79   79. Travel agency, tour operator and other reservation service and related activities
          80   80. Security and investigation activities
          81   81. Services to buildings and landscape activities
          82   82. Office administrative, office support and other business support activities
          84   84. Public administration and defence; compulsory social security
          85   85. Education
          86   86. Human health activities
          87   87. Residential care activities
          88   88. Social work activities without accommodation
          90   90. Creative, arts and entertainment activities
          91   91. Libraries, archives, museums and other cultural activities
          92   92. Gambling and betting activities
          93   93. Sports activities and amusement and recreation activities
          94   94. Activities of membership organisations
          95   95. Repair of computers and personal and household goods
          96   96. Other personal service activities
          97   97. Activities of households as employers of domestic personnel
          98   98. Undifferentiated goods- and services-producing activities of private households for own use
          99   99. Activities of extraterritorial organisations and bodies


*/







/*

** UK SOC 2000 3-digit codes: 


         111   111. Corporate managers and senior officials
         112   112. Production managers
         113   113. Functional managers
         114   114. Quality and customer care managers
         115   115. Financial institution and office managers
         116   116. Managers in distribution, storage and retailing
         117   117. Protective service officers
         118   118. Health and social services managers
         121   121. Managers in farming, horticulture, forestry and services
         122   122. Managers and proprietors in hospitality and leisure services
         123   123. Managers and proprietors in other service industries
         211   211. Science professionals
         212   212. Engineering professionals
         213   213. Information and communication technology professionals
         221   221. Health professionals
         231   231. Teaching professionals
         232   232. Research professionals
         241   241. Legal professionals
         242   242. Business and statistical professionals
         243   243. Architects, town planners, surveyors
         244   244. Public service professionals
         245   245. Librarians and related professionals
         311   311. Science and engineering technicians
         312   312. Draughtspersons and building inspectors
         313   313. It service delivery occupations
         321   321. Health associate professionals
         322   322. Therapists
         323   323. Social welfare associate professionals
         331   331. Protective service occupations
         341   341. Artistic and literary occupations
         342   342. Design associate professionals
         343   343. Media associate professionals
         344   344. Sports and fitness occupations
         351   351. Transport associate professionals
         352   352. Legal associate professionals
         353   353. Business and finance associate professionals
         354   354. Sales and related associate professionals
         355   355. Conservation associate professionals
         356   356. Public service and other associate professionals
         411   411. Administrative occupations: government and related organisations
         412   412. Administrative occupations: finance
         413   413. Administrative occupations: records
         414   414. Administrative occupations: communications
         415   415. Administrative occupations: general
         421   421. Secretarial and related occupations
         511   511. Agricultural trades
         521   521. Metal forming, welding and related trades
         522   522. Metal machining, fitting and instrument making trades
         523   523. Vehicle trades
         524   524. Electrical trades
         531   531. Construction trades
         532   532. Building trades
         541   541. Textiles and garments trades
         542   542. Printing trades
         543   543. Food preparation trades
         549   549. Skilled trades nec
         611   611. Healthcare and related personal services
         612   612. Childcare and related personal services
         613   613. Animal care services
         621   621. Leisure and travel service occupations
         622   622. Hairdressers and related occupations
         623   623. Housekeeping occupations
         629   629. Personal services occupations nec
         711   711. Sales assistants and retail cashiers
         712   712. Sales related occupations
         721   721. Customer service occupations
         811   811. Process operatives
         812   812. Plant and machine operatives
         813   813. Assemblers and routine operatives
         814   814. Construction operatives
         821   821. Transport drivers and operatives
         822   822. Mobile machine drivers and operatives
         911   911. Elementary agricultural occupations
         912   912. Elementary construction occupations
         913   913. Elementary process plant occupations
         914   914. Elementary goods storage occupations
         921   921. Elementary administration occupations
         922   922. Elementary personal services occupations
         923   923. Elementary cleaning occupations
         924   924. Elementary security occupations
         925   925. Elementary sales occupations


*/


************************************************************************
************************************************************************