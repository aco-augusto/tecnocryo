#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "FONT.CH"
#INCLUDE "MSOBJECT.CH" 
#include "TOTVS.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "RPTDEF.CH"  

Class TWFormularioDEB From LongClassName
		
	Data cTitulo 
	Data cNome 
	Data cCNPJ
	Data cEndereco
	Data cBairro
	Data cCEP
	Data cMunicipio
	Data cFone
	Data cUF
	Data cIE
	Data cCodigo
	Data cDescricao 
	Data cDocumento  
	Data cClieteDe
	Data cClienteAte
	Data cNFDe
	Data cNFAte 
	
	Data cLogo 
	Data dDataEmissao 
	Data dDataVencimento		    
	Data dDataDe
	Data dDataAte
	
	Data nQuantidade 
	Data nValorUnitario
	Data nValorTotal
	Data nAnt            
	Data nCurrentPrint
	
	Data lLimitePorPagina
	
	Data oPrint
	
	Data aDestinatario
	
	Method New() Constructor 		// Metodo construtor 
	Method ConfigLayoutCabecalho()  // Determina as configurações do Layout  
	Method AcionaImpressa()    
	Method ObtemDadosNF()
	Method ImprimeItens()   
	Method ImprimeProdutosPendentes()
	Method ObtemVencimentoFatura()    
	Method Init()

EndClass

Method New() Class TWFormularioDEB
 	
	::cTitulo		  := "" 
	::cNome			  := "" 
	::cCNPJ			  := ""
	::cEndereco	  	  := ""
	::cBairro		  := ""
	::cCEP			  := ""
	::cMunicipio	  := ""
	::cFone			  := ""
	::cUF			  := ""
	::cIE			  := ""
	::cCodigo	  	  := ""
	::cDescricao  	  := ""  
	::cDocumento	  := ""                           
	::cNFDe			  := "" 
	::cNFAte		  := ""	
	::cLogo			  := Curdir() + "logo\NFlogo.bmp"	
	
	::dDataEmissao	  := CTOD("")  
	::dDataVencimento := CTOD("")  
	::nAnt			  := 0  
	::nCurrentPrint   := 0 
	::nValorTotal	  := 0
	
	::lLimitePorPagina:= .F.	   	
	
	::aDestinatario	  := {}	
	::oPrint		  := Nil
	
Return   	

/**/   
                                   
Method Init() Class TWFormularioDEB    

Return 

/**/

Method ConfigLayoutCabecalho()  Class TWFormularioDEB
	
	Local oFont8
	Local oFont12n
	
	Local nRow := 0 	
	Local nCol := 0 

	oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
								   
	::oPrint:StartPage()    // Inicia uma nova página	
	
	nRow := 040
	nCol := 030

	::oPrint:SayBitmap(nRow, nCol, ::cLogo, 100, 050)
	
	//____________________________________________________________________________________________
	//                                                                                            |  
	// Dados ligados a identificação da Empresa                                                   |
	//____________________________________________________________________________________________|
	 
	::oPrint:Say(nRow 	 , nCol + 110, SM0->M0_NOMECOM, oFont12n)  
	
	::oPrint:Say(nRow + 015, nCol + 110, cFilAnt +" - "+ FWFilName (cEmpAnt, cFilAnt )					, oFont12n)  
	::oPrint:Say(nRow + 030, nCol + 110, "ENDEREÇO: "+SM0->M0_ENDENT+""									, oFont12n)  
	::oPrint:Say(nRow + 045, nCol + 110, "BAIRRO/DISTRITO: "+SM0->M0_BAIRENT+""							, oFont12n)  	 
	::oPrint:Say(nRow + 060, nCol + 110, "MUNICIPIO: "+Alltrim(SM0->M0_CIDENT)+" "						, oFont12n) 
	::oPrint:Say(nRow + 075, nCol + 110, "UF: "+Alltrim(SM0->M0_ESTENT)+""								, oFont12n)  			 		
	::oPrint:Say(nRow + 090, nCol + 110, "CEP: "+Transform(Alltrim(SM0->M0_CEPENT),"@R 99.999-999")+""	, oFont12n)  		
	
	
	//____________________________________________________________________________________________
	//                                                                                            | 
	// NOTA DE COBRANÇA | Nº                                                                      |
	//____________________________________________________________________________________________|
	                             
	::oPrint:Box( nRow + 015 , 475, nRow + 050		 , 565, "-4")    
	::oPrint:Say( nRow + 024 , 478, "NOTA COBRANÇA"  , oFont12n) 
	::oPrint:Say( nRow + 040 , 478, ::cDocumento 	 , oFont12n) 
	                                                         
	 
	//____________________________________________________________________________________________
	//                                                                                            | 
	// CNPJ                                                                      				  |
	//____________________________________________________________________________________________|
	                             	
	::oPrint:Box( nRow + 105, 252, 200, 465												  , "-4")       // Caixa Principal
	::oPrint:Say( nRow + 118, 255, "CNPJ"												  , oFont12n)  	//
	::oPrint:Say( nRow + 131, 255, Transform(Alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99"), oFont8)   	//
	
		
	::oPrint:Box( nRow + 132, 252, nRow + 132, 465, "-4") 												// Linha Divisória  
	::oPrint:Say( nRow + 145, 255, "INSCRIÇÃO ESTADUAL"	, oFont12n) 									// 
	::oPrint:Say( nRow + 158, 255, SM0->M0_INSC		, oFont8)   										//	

	//____________________________________________________________________________________________
	//                                                                                            | 
	// EMISSÃO                                                                      			  |
	//____________________________________________________________________________________________|	

	::oPrint:Box( nRow + 105, 475, 172		 , 565, "-4") 
	::oPrint:Say( nRow + 113, 478, "EMISSÃO" , oFont12n) 

	::oPrint:Box( nRow + 118, 475, nRow + 118, 565 , "-4") 
	::oPrint:Say( nRow + 130, 478, DToC(dDataBase) , oFont8) 	
	
	//____________________________________________________________________________________________
	//                                                                                            | 
	// DESTINATÁRIO                                                                      		  |
	//____________________________________________________________________________________________|	
	
	nRow := 210
	
	::oPrint:Say(nRow - 005	, nCol, "DESTINATÁRIO"	, oFont12n)  

	::oPrint:Box( nRow 		, nCol		, nRow + 085			, 565, "-4")   				// Caixa Principal   
	::oPrint:Say(nRow + 013	, nCol + 003, "NOME/RAZÃO SOCIAL" 	, oFont12n)  				// 
	::oPrint:Say(nRow + 028	, nCol + 003, SA1->A1_NOME , oFont8  )  						// 
			

	::oPrint:Box( nRow 	 	, 415, nRow + 030, 565 	, "-4")  						   		// Linha divisória Vertical 
	::oPrint:Say( nRow + 013, 418, "CPF/CNPJ"		, oFont12n)  		 					// 
    ::oPrint:Say( nRow + 028, 418, SA1->A1_CGC	, oFont8)     
    
    //______________________________________________________________________________________
    //                                                                                      |                                   
    //                                                                                      |
    //______________________________________________________________________________________|
    
    ::oPrint:Box( nRow + 060 , 215, nRow + 085, 565 	, "-4")								// Linha divisória Vertical 
    ::oPrint:Say( nRow + 073 , 218, "FONE"	, oFont12n)                         			// 
	::oPrint:Say( nRow + 083 , 218, SA1->A1_TEL	, oFont8)  									//
	
    ::oPrint:Box( nRow + 060 , 303, nRow + 085, 565 	, "-4")								// Linha divisória Vertical 

	::oPrint:Box( nRow + 030 , 300, nRow + 085, 565 	, "-4")                             // Linha divisória Vertical
	::oPrint:Say( nRow + 043 , 303, "BAIRRO/DISTRITO"	, oFont12n) 
	::oPrint:Say( nRow + 058 , 303, SA1->A1_BAIRRO		, oFont8)  							// 
	
	::oPrint:Box( nRow + 030 , 490, nRow + 060, 565 	, "-4")                             // Linha divisória Vertical	  
	::oPrint:Say( nRow + 043 , 493, "CEP"				, oFont12n)                         // 
	::oPrint:Say( nRow + 058 , 493, SA1->A1_CEP			, oFont8)  							// 
	
	::oPrint:Box( nRow + 060 , 400, nRow + 085, 565 	, "-4")                             // Linha divisória Vertical
	::oPrint:Say( nRow + 073 , 403, "INSC. ESTADUAL"	, oFont12n)                         // 
	::oPrint:Say( nRow + 083 , 403, SA1->A1_INSCR		, oFont8)  							// 

	              
	::oPrint:Box( nRow + 030 , nCol, nRow + 030, 565 	, "-4")  							// Primeira Linha divisória  Horizontal
	::oPrint:Say( nRow + 043 , nCol + 003, "ENDEREÇO"	, oFont12n)  						// 
	::oPrint:Say( nRow + 058 , nCol + 003, SA1->A1_END	, oFont8)  							// 
	
	
	::oPrint:Box( nRow + 060 , nCol, nRow + 060, 565	, "-4")  							// Segunda Linha divisória Horizontal
	::oPrint:Say( nRow + 073 , nCol + 003, "MUNICÍPIO"	, oFont12n)  						// 
	::oPrint:Say( nRow + 083 , nCol + 003, SA1->A1_MUN	, oFont8)  							// 
	
	
	::oPrint:Say( nRow + 073 , 303, "UF"				, oFont12n)                         // 
	::oPrint:Say( nRow + 083 , 303, SA1->A1_EST         , oFont8)  							//  
					   
Return                                             

/**/

Method AcionaImpressa() Class TWFormularioDEB
     
	::oPrint:EndPage() 		// Finaliza a página  
	::oPrint:Preview()		// Vizualizar
Return 
              
/**/

Method ImprimeItens() Class TWFormularioDEB
                          
	Local cMsg 		:= ""
	Local nRow 		:= 320
	Local nCol 		:= 030  
	Local nK		:= 0
	
	Local aAux 		:= {}                         
	Local oFont8	:= Nil 
	Local oFont12n 	:= Nil
	
	
	oFont8   		:= TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.) 
	oFont12n 		:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.) 
	
	//____________________________________________________________________________________________
	//                                                                                            | 
	// DADOS DO DOCUMENTO                                                                      	  |
	//____________________________________________________________________________________________| 
	
	::oPrint:Say( nRow  , nCol, "DADOS DO DOCUMENTO", oFont12n)         				// 
	
	::oPrint:Box( nRow + 010, nCol, nRow + 040, 565, "-4") 								// Caixa correspondente ao cabeçalho
	
	::oPrint:Say( nRow + 030, nCol + 003, "CÓDIGO", oFont12n)         					// 

	::oPrint:Box( nRow + 010, nCol + 070, nRow + 040, nCol + 070, "-4")     			// Primeira Linha Divisória Vertical     
	
	::oPrint:Say( nRow + 030, nCol + 075, "DESCRIÇÃO", oFont12n)         				// 
	
	::oPrint:Box( nRow + 010, nCol + 300, nRow + 040, nCol + 300, "-4")     			// Segunda Linha Divisória Vertical
	::oPrint:Say( nRow + 030, nCol + 303, "QUANT.", oFont12n)         					// 
	     
	::oPrint:Box( nRow + 010, nCol + 380, nRow + 040, nCol + 380, "-4")     			// Terceira Linha Divisória Vertical  	
	::oPrint:Say( nRow + 030, nCol + 383, "VLR.UNIT.", oFont12n)         				//
	
	::oPrint:Box( nRow + 010, nCol + 460, nRow + 040, nCol + 460, "-4")     			// Quarta Linha Divisória
	::oPrint:Say( nRow + 030, nCol + 463, "VLR.TOT.", oFont12n)         				//       
	
	//___________________________________________________________________________________  
	//                                                                                   | 
	// Parte que controla a impressão dos dados                                          |
	//___________________________________________________________________________________| 
	
	aAux := ::aDestinatario[::nAnt][3]
	
	For nK := 1 To  Len(aAux) 
	        
			If ::lLimitePorPagina 
			
				 If nK > ::nCurrentPrint 
				 	
				 	::oPrint:Say( nRow + 060, nCol + 003, aAux[nK][1]     , oFont8)  
				 	::oPrint:Say( nRow + 060, nCol + 075, aAux[nK][2]	  , oFont8)  	        
		         	::oPrint:Say( nRow + 060, nCol + 303, STR(aAux[nK][3]), oFont8)  
			  	 	::oPrint:Say( nRow + 060, nCol + 383, STR(aAux[nK][4]), oFont8)
			  	 	::oPrint:Say( nRow + 060, nCol + 463, STR(aAux[nK][5]), oFont8) 
			  	 	
			  	 	::nCurrentPrint := nK
				 	nRow += 012 
				 End If
			Else
	        	 ::oPrint:Say( nRow + 060, nCol + 003, aAux[nK][1]     , oFont8)  
				 ::oPrint:Say( nRow + 060, nCol + 075, aAux[nK][2]	  , oFont8)  	        
		         ::oPrint:Say( nRow + 060, nCol + 303, STR(aAux[nK][3]), oFont8)  
			  	 ::oPrint:Say( nRow + 060, nCol + 383, STR(aAux[nK][4]), oFont8)
			  	 ::oPrint:Say( nRow + 060, nCol + 463, STR(aAux[nK][5]), oFont8)
			  	 
				 nRow += 012		  	
				 
		  	End If
		  	      
		  	//____________________________________________________________
		  	//                                                            | 
		  	// Controle de limite de impressão                            |
		  	//____________________________________________________________|
		  	If  nRow >= 440          
		  	
		  	       ::lLimitePorPagina := .T.  
		  	       ::nCurrentPrint    := nK
		  	       
		  	       Exit  
		  	End If  
		   
	Next nK
	
	nRow := 510 
		
	
	::oPrint:Box( nRow , nCol + 297, nRow + 040, 565, "-4") 									// Caixa com o valor Total 
	
	::oPrint:Say( nRow + 020, nCol + 303, "VALOR TOTAL DA NOTA DE COBRANÇA", oFont12n)  		//
	::oPrint:Say( nRow + 035, nCol + 303, Transform(::nValorTotal, "@E 999,999.99"), oFont12n)  //
	
	::oPrint:Box( nRow + 058, nCol + 003, nRow + 240, 565, "-4") 															  // Caixa cujo conteúdo será preenchido com as observações
	::oPrint:Say( nRow + 056, nCol + 006, "INFORMAÇÕES ADICIONAIS"												  ,	oFont12n) //
	::oPrint:Say( nRow + 073, nCol + 006, "Nosso site: http://www.tecnocryo.com.br/"							  , oFont8)	  // 
	::oPrint:Say( nRow + 083, nCol + 006, "E-mail: contato@tecnocryo.com.br"									  , oFont8)	  // 
	::oPrint:Say( nRow + 093, nCol + 006, "Atendimento a clientes - Tel.: (027)3325-6533"						  , oFont8)	  // 
	::oPrint:Say( nRow + 103, nCol + 006, "OPERAÇÃO NÃO SUJEITA AO I.S.S DE ACORDO COM A LEI COMPLEMENTAR 116/03" , oFont8)	  // 
	
	::oPrint:Say( nRow + 123, nCol + 006, "VENCIMENTO: "+DTOC(::aDestinatario[::nAnt][4])+"   CLIENTE: "+SubStr(::aDestinatario[::nAnt][1],1,9)+"", oFont8)  															  //
	
	
	
	::oPrint:Box( nRow + 260, nCol + 003, nRow + 0300, 565, "-4") 								// Última caixa da página 
	
	
	::oPrint:Box( nRow + 275, nCol + 003, nRow + 275, 565 , "-4")     		            		// Linha Divisória Horizontal   
	
	cMsg := "EM CASO DE LOCAÇÃO, ATESTAMOS QUE OS DADOS ACIMA CONFEREM COM OS BENS CEDIDOS EM LOCAÇÃO."
	
	::oPrint:Say( nRow + 273, nCol + 006, cMsg, oFont8)  										//
	
	::oPrint:Box( nRow + 275, nCol + 190, nRow + 300, nCol + 190 , "-4")                		// Linha Divisória Vertical
	::oPrint:Say( nRow + 290, nCol + 006, "DATA DO RECEBIMENTO:", oFont8)  			    		//
	::oPrint:Say( nRow + 290, nCol + 193, "IDENT./ASS. RECEBEDOR:", oFont8)  					//
	
	
	::oPrint:Box( nRow + 275, nCol + 380, nRow + 300, nCol + 380 , "-4")                		// Linha Divisória Vertical         	
	::oPrint:Say( nRow + 290, nCol + 383, "NOTA COBRANÇA. Nº: "+::cDocumento+" ", oFont8)  		//
	
Return  

/**/
Method ImprimeProdutosPendentes() Class TWFormularioDEB
	        
	  
	  While ::nCurrentPrint < Len(::aDestinatario[::nAnt][3])
	  		
	  		::ConfigLayoutCabecalho()
      
      		::ImprimeItens()
    	 
      	   If  ::nCurrentPrint == Len(::aDestinatario[::nAnt][3])
      	       
      	         ::lLimitePorPagina := .F.
      	       
      	         Exit 
      	   End If 	
      End 

Return 

                    

/**/
Method ObtemDadosNF() Class TWFormularioDEB
	
	Local cWorkArea := GetNextAlias()
	Local cSQL		:= ""	               
	
    cSQL += "SELECT 	 	 	  " 
    cSQL += "A1_COD			 	 ," 
    cSQL += "A1_LOJA			 ," 
    cSQL += "A1_NOME			 ," 
    cSQL += "A1_END				 ," 
    cSQL += "A1_EST				 ," 
    cSQL += "A1_INSCR			 ," 
    cSQL += "A1_MUN				 ," 
	cSQL += "A1_BAIRRO			 ,"
	cSQL += "A1_CGC				 ,"  
	cSQL += "A1_CEP				 ," 
	cSQL += "D2_EMISSAO			 ," 
	cSQL += "A1_DDD + A1_TEL	 ,"
	cSQL += "A1_FAX				 ,"
	cSQL += "D2_PEDIDO			 ,"
	cSQL += "D2_ITEM			 ,"
	cSQL += "B1_COD				 ,"
	cSQL += "B1_DESC			 ,"
	cSQL += "D2_PRCVEN			 ,"
	cSQL += "D2_TOTAL AS D2_TOTAL,"
	cSQL += "D2_QUANT 			 ," 
	cSQL += "D2_DOC 			 ,"  
	cSQL += "E1_VENCREA			  "  
	cSQL += "FROM " +RetSqlName("SD2")+" AS SD2 JOIN " + RetSqlName("SA1")+" SA1 "
	
	
	cSQL += "ON A1_COD = D2_CLIENTE " 
	cSQL += "AND A1_LOJA = D2_LOJA  "
	cSQL += "JOIN  " +RetSqlName("SB1")+" SB1 ON "
	cSQL += "D2_COD = B1_COD 	"                
	
	cSQL += "INNER JOIN  " +RetSqlName("SF2")+" SF2 ON  "
	cSQL +=" SF2.D_E_L_E_T_=''							"	
    cSQL += "AND SF2.F2_FILIAL 	= "+xFilial("SF2")+" 	" 
	cSQL +=" AND SF2.F2_FILIAL  = SD2.D2_FILIAL 		"
	cSQL +=" AND SF2.F2_DOC     = SD2.D2_DOC			"
	cSQL +=" AND SF2.F2_CLIENTE = SA1.A1_COD			"
	cSQL +=" AND SF2.F2_LOJA    = SA1.A1_LOJA  			"
	cSQL +=" AND SF2.F2_CLIENTE	= SD2.D2_CLIENTE 		"
	cSQL +=" AND SF2.F2_LOJA    = SD2.D2_LOJA			"
	
	cSQL += " LEFT JOIN  " +RetSqlName("SE1")+" SE1 ON  "
	cSQL += " SE1.E1_FILIAL 	  = "+xFilial("SE1")+" 	" 
	cSQL += " AND SE1.D_E_L_E_T_  =''    				"	
	cSQL += " AND SE1.E1_FILIAL	  = SF2.F2_FILIAL		"
	cSQL += " AND SE1.E1_PREFIXO  = SF2.F2_PREFIXO		"
	cSQL += " AND SE1.E1_NUM	  = SF2.F2_DOC      	"
	cSQL += " AND SE1.E1_CLIENTE  = SF2.F2_CLIENTE  	"
	cSQL += " AND SE1.E1_LOJA	  = SF2.F2_LOJA     	"
	cSQL += " AND SE1.E1_SERIE    = SF2.F2_SERIE    	"
	cSQL += " AND SE1.E1_NUM	  = SD2.D2_DOC      	"
	cSQL += " AND SE1.E1_SERIE    = SD2.D2_SERIE    	" 
	cSQL += " AND SE1.E1_CLIENTE  = SD2.D2_CLIENTE  	"
	cSQL += " AND SE1.E1_CLIENTE  = SA1.A1_COD      	" 
	cSQL += " AND SE1.E1_LOJA	  = SA1.A1_LOJA     	"
	
	cSQL += "WHERE SD2.D_E_L_E_T_ <> '*' 				"
	cSQL += "AND SB1.D_E_L_E_T_ <> '*' 					" 
	cSQL += "AND SA1.D_E_L_E_T_ <> '*'	 				"
	cSQL += "AND A1_FILIAL 	= "+xFilial("SA1")+" 		" 
	cSQL += "AND B1_FILIAL  = "+xFilial("SB1")+"  		" 
	
	If !Empty(::dDataAte) 
		cSQL += "AND SF2.F2_EMISSAO BETWEEN '"+::dDataDe+"' AND '"+::dDataAte+"' "      
	End If  
	
	If !Empty(::cClienteAte) 
		cSQL += "AND SF2.F2_CLIENTE BETWEEN '"+::cClieteDe+"' AND '"+::cClienteAte+"' "      
	End If  
	
	If !Empty(::cNFAte) 
		cSQL += "AND SF2.F2_DOC BETWEEN '"+::cNFDe+"' AND '"+::cNFAte+"' "      
	End If
	
	
	
	                               
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cSQL), cWorkArea, .T., .F. )

    While (cWorkArea)->(!Eof())
    	 
           nPos :=  aScan(::aDestinatario,{|x| Alltrim(x[2]) == (cWorkArea)->(D2_DOC) })  
           
           If nPos  == 0
                 
            	 aAdd(::aDestinatario, {  (cWorkArea)->(A1_COD + A1_LOJA) ,;  
            	 						  (cWorkArea)->(D2_DOC)			  ,;
            	 						  {{ (cWorkArea)->B1_COD   		  ,;
            	  						     (cWorkArea)->B1_DESC  		  ,;
            	  						     (cWorkArea)->D2_PRCVEN		  ,;
            	  						     (cWorkArea)->D2_QUANT		  ,;
            	  						     (cWorkArea)->D2_TOTAL         ;
            	                          }} ,;
            	                          STOD((cWorkArea)->(E1_VENCREA));        // STOD
            	                       }; 
            	 ) 
            	 
           Else 
				 
				 aAdd(::aDestinatario[nPos][3], {   					    ;
                								  (cWorkArea)->B1_COD      ,;
            	  						          (cWorkArea)->B1_DESC     ,;
            	  						          (cWorkArea)->D2_PRCVEN   ,;
            	  						          (cWorkArea)->D2_QUANT	   ,;
            	  						          (cWorkArea)->D2_TOTAL     ;
            	                               }; 
            	 ) 

				 							           		
           End If                      
          
           (cWorkArea)->(dbSkip())
    End Do
	
Return  

