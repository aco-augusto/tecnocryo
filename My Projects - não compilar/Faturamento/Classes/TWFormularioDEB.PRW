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
	Data cPathPDF
	Data cFile
	
	Data lEnviado
	
	Data aRecSE1
	
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
	Method ConfigLayoutCabecalho()  // Determina as configura��es do Layout  
	Method AcionaImpressa()    
	Method ObtemDadosNF()
	Method ImprimeItens()   
	Method ImprimeProdutosPendentes()
	Method ObtemVencimentoFatura()    
	Method Init()
	Method PopDest()
	Method Enviar()	
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
	::cPathPDF        := ""
	::cFile           := ""
	
	::dDataEmissao	  := CTOD("")  
	::dDataVencimento := CTOD("")  
	::nAnt			  := 0  
	::nCurrentPrint   := 0 
	::nValorTotal	  := 0
	
	::lLimitePorPagina:= .F.	   	
	::lEnviado        := .F.
	
	::aDestinatario	  := {}	 
	::aRecSE1         := {}
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
								   
	::oPrint:StartPage()    // Inicia uma nova p�gina	
	
	nRow := 040
	nCol := 030

	::oPrint:SayBitmap(nRow, nCol, ::cLogo, 100, 050)
	
	//____________________________________________________________________________________________
	//                                                                                            |  
	// Dados ligados a identifica��o da Empresa                                                   |
	//____________________________________________________________________________________________|
	 
	::oPrint:Say(nRow 	 , nCol + 110, SM0->M0_NOMECOM, oFont12n)  
	
	::oPrint:Say(nRow + 015, nCol + 110, cFilAnt +" - "+ FWFilName (cEmpAnt, cFilAnt )					, oFont12n)  
	::oPrint:Say(nRow + 030, nCol + 110, "ENDERE�O: "+SM0->M0_ENDENT+""									, oFont12n)  
	::oPrint:Say(nRow + 045, nCol + 110, "BAIRRO/DISTRITO: "+SM0->M0_BAIRENT+""							, oFont12n)  	 
	::oPrint:Say(nRow + 060, nCol + 110, "MUNICIPIO: "+Alltrim(SM0->M0_CIDENT)+" "						, oFont12n) 
	::oPrint:Say(nRow + 075, nCol + 110, "UF: "+Alltrim(SM0->M0_ESTENT)+""								, oFont12n)  			 		
	::oPrint:Say(nRow + 090, nCol + 110, "CEP: "+Transform(Alltrim(SM0->M0_CEPENT),"@R 99.999-999")+""	, oFont12n)  		
	
	
	//____________________________________________________________________________________________
	//                                                                                            | 
	// NOTA DE COBRAN�A | N�                                                                      |
	//____________________________________________________________________________________________|
	                             
	::oPrint:Box( nRow + 015 , 475, nRow + 050		 , 565, "-4")    
	::oPrint:Say( nRow + 024 , 478, "NOTA COBRAN�A"  , oFont12n) 
	::oPrint:Say( nRow + 040 , 478, ::cDocumento 	 , oFont12n) 
	                                                         
	 
	//____________________________________________________________________________________________
	//                                                                                            | 
	// CNPJ                                                                      				  |
	//____________________________________________________________________________________________|
	                             	
	::oPrint:Box( nRow + 105, 252, 200, 465												  , "-4")       // Caixa Principal
	::oPrint:Say( nRow + 118, 255, "CNPJ"												  , oFont12n)  	//
	::oPrint:Say( nRow + 131, 255, Transform(Alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99"), oFont8)   	//
	
		
	::oPrint:Box( nRow + 132, 252, nRow + 132, 465, "-4") 												// Linha Divis�ria  
	::oPrint:Say( nRow + 145, 255, "INSCRI��O ESTADUAL"	, oFont12n) 									// 
	::oPrint:Say( nRow + 158, 255, SM0->M0_INSC		, oFont8) 
	
	SF2->(DbSetOrder(1))
	SF2->(DbSeek(xFilial("SF2") + ::cDocumento + ::aDestinatario[::nAnt,06]))

	//____________________________________________________________________________________________
	//                                                                                            | 
	// EMISS�O                                                                      			  |
	//____________________________________________________________________________________________|	

	::oPrint:Box( nRow + 105, 475, 172		 , 565, "-4") 
	::oPrint:Say( nRow + 113, 478, "EMISS�O" , oFont12n) 

	::oPrint:Box( nRow + 118, 475, nRow + 118, 565 , "-4") 
	::oPrint:Say( nRow + 130, 478, DToC(SF2->F2_EMISSAO) , oFont8) 	
	
	//____________________________________________________________________________________________
	//                                                                                            | 
	// DESTINAT�RIO                                                                      		  |
	//____________________________________________________________________________________________|	
	
	nRow := 210
	
	::oPrint:Say(nRow - 005	, nCol, "DESTINAT�RIO"	, oFont12n)   
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + SF2->(F2_CLIENTE + F2_LOJA)))

	::oPrint:Box( nRow 		, nCol		, nRow + 085			, 565, "-4")   				// Caixa Principal   
	::oPrint:Say(nRow + 013	, nCol + 003, "NOME/RAZ�O SOCIAL" 	, oFont12n)  				// 
	::oPrint:Say(nRow + 028	, nCol + 003, SA1->A1_NOME , oFont8  )  						// 
			

	::oPrint:Box( nRow 	 	, 415, nRow + 030, 565 	, "-4")  						   		// Linha divis�ria Vertical 
	::oPrint:Say( nRow + 013, 418, "CPF/CNPJ"		, oFont12n)  		 					// 
    ::oPrint:Say( nRow + 028, 418, SA1->A1_CGC	, oFont8)     
    
    //______________________________________________________________________________________
    //                                                                                      |                                   
    //                                                                                      |
    //______________________________________________________________________________________|
    
    ::oPrint:Box( nRow + 060 , 215, nRow + 085, 565 	, "-4")								// Linha divis�ria Vertical 
    ::oPrint:Say( nRow + 073 , 218, "FONE"	, oFont12n)                         			// 
	::oPrint:Say( nRow + 083 , 218, SA1->A1_TEL	, oFont8)  									//
	
    ::oPrint:Box( nRow + 060 , 303, nRow + 085, 565 	, "-4")								// Linha divis�ria Vertical 

	::oPrint:Box( nRow + 030 , 300, nRow + 085, 565 	, "-4")                             // Linha divis�ria Vertical
	::oPrint:Say( nRow + 043 , 303, "BAIRRO/DISTRITO"	, oFont12n) 
	::oPrint:Say( nRow + 058 , 303, SA1->A1_BAIRRO		, oFont8)  							// 
	
	::oPrint:Box( nRow + 030 , 490, nRow + 060, 565 	, "-4")                             // Linha divis�ria Vertical	  
	::oPrint:Say( nRow + 043 , 493, "CEP"				, oFont12n)                         // 
	::oPrint:Say( nRow + 058 , 493, SA1->A1_CEP			, oFont8)  							// 
	
	::oPrint:Box( nRow + 060 , 400, nRow + 085, 565 	, "-4")                             // Linha divis�ria Vertical
	::oPrint:Say( nRow + 073 , 403, "INSC. ESTADUAL"	, oFont12n)                         // 
	::oPrint:Say( nRow + 083 , 403, SA1->A1_INSCR		, oFont8)  							// 

	              
	::oPrint:Box( nRow + 030 , nCol, nRow + 030, 565 	, "-4")  							// Primeira Linha divis�ria  Horizontal
	::oPrint:Say( nRow + 043 , nCol + 003, "ENDERE�O"	, oFont12n)  						// 
	::oPrint:Say( nRow + 058 , nCol + 003, SA1->A1_END	, oFont8)  							// 
	
	
	::oPrint:Box( nRow + 060 , nCol, nRow + 060, 565	, "-4")  							// Segunda Linha divis�ria Horizontal
	::oPrint:Say( nRow + 073 , nCol + 003, "MUNIC�PIO"	, oFont12n)  						// 
	::oPrint:Say( nRow + 083 , nCol + 003, SA1->A1_MUN	, oFont8)  							// 
	
	
	::oPrint:Say( nRow + 073 , 303, "UF"				, oFont12n)                         // 
	::oPrint:Say( nRow + 083 , 303, SA1->A1_EST         , oFont8)  							//  
					   
Return                                             

/**/

Method AcionaImpressa() Class TWFormularioDEB
     
	::oPrint:EndPage() 		// Finaliza a p�gina  
	::oPrint:Preview()		// Vizualizar
Return 
              
/**/

Method ImprimeItens() Class TWFormularioDEB
Local cMsg 		 := ""
Local nRow 		 := 320
Local nCol 		 := 030  
Local nK		 := 0
Local aAux 		 := {}                         
Local oFont8	 := TFont():New("Courier New",9,8,.T.,.F.,5,.T.,5,.T.,.F.) 
Local oFont12n 	 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.) 
Local aArea      := GetArea()
Local cPicPrcVen := ""
Local cPicQuant  := ""
Local cPicTotal  := ""

	DbSelectArea("SD2")  
	
	cPicPrcVen := X3Picture("D2_PRCVEN")
	cPicQuant  := X3Picture("D2_QUANT")
	cPicTotal  := X3Picture("D2_TOTAL")

	RestArea(aArea)	

	//____________________________________________________________________________________________
	//                                                                                            | 
	// DADOS DO DOCUMENTO                                                                      	  |
	//____________________________________________________________________________________________| 
	
	::oPrint:Say( nRow  , nCol, "DADOS DO DOCUMENTO", oFont12n)         				// 
	
	::oPrint:Box( nRow + 010, nCol, nRow + 040, 565, "-4") 								// Caixa correspondente ao cabe�alho
	
	::oPrint:Say( nRow + 030, nCol + 003, "C�DIGO", oFont12n)         					// 

	::oPrint:Box( nRow + 010, nCol + 070, nRow + 040, nCol + 070, "-4")     			// Primeira Linha Divis�ria Vertical     
	
	::oPrint:Say( nRow + 030, nCol + 075, "DESCRI��O", oFont12n)         				// 
	
	::oPrint:Box( nRow + 010, nCol + 300, nRow + 040, nCol + 300, "-4")     			// Segunda Linha Divis�ria Vertical
	::oPrint:Say( nRow + 030, nCol + 303, "QUANT.", oFont12n)         					// 
	     
	::oPrint:Box( nRow + 010, nCol + 380, nRow + 040, nCol + 380, "-4")     			// Terceira Linha Divis�ria Vertical  	
	::oPrint:Say( nRow + 030, nCol + 383, "VLR.UNIT.", oFont12n)         				//
	
	::oPrint:Box( nRow + 010, nCol + 460, nRow + 040, nCol + 460, "-4")     			// Quarta Linha Divis�ria
	::oPrint:Say( nRow + 030, nCol + 463, "VLR.TOT.", oFont12n)         				//       
	
	//___________________________________________________________________________________  
	//                                                                                   | 
	// Parte que controla a impress�o dos dados                                          |
	//___________________________________________________________________________________| 
	
	aAux := ::aDestinatario[::nAnt][3]   

	For nK := 1 To  Len(aAux) 
	        
			If ::lLimitePorPagina 
			
				 If nK > ::nCurrentPrint 
				 	
				 	::oPrint:Say( nRow + 060, nCol + 003, aAux[nK][1]     , oFont8)  
				 	::oPrint:Say( nRow + 060, nCol + 075, aAux[nK][2]	  , oFont8)  	        

		         	::oPrint:Say( nRow + 060, nCol + 325, Transform(aAux[nK][4], cPicQuant), oFont8)  //
			  	 	::oPrint:Say( nRow + 060, nCol + 373, Transform(aAux[nK][3], cPicPrcVen), oFont8)  //D2_PRCVEN
			  	 	::oPrint:Say( nRow + 060, nCol + 468, Transform(aAux[nK][5], cPicTotal), oFont8)  //D2_TOTAL
			  	 	
			  	 	::nCurrentPrint := nK
				 	nRow += 012 
				 End If
			Else
	        	 ::oPrint:Say( nRow + 060, nCol + 003, aAux[nK][1]     , oFont8)  
				 ::oPrint:Say( nRow + 060, nCol + 075, aAux[nK][2]	  , oFont8)  	        
		         //::oPrint:Say( nRow + 060, nCol + 303, STR(aAux[nK][3]), oFont8)  
			  	 //::oPrint:Say( nRow + 060, nCol + 383, STR(aAux[nK][4]), oFont8)
			  	 //::oPrint:Say( nRow + 060, nCol + 463, STR(aAux[nK][5]), oFont8)   
		         ::oPrint:Say( nRow + 060, nCol + 325, Transform(aAux[nK][4], cPicQuant), oFont8)  //
			  	 ::oPrint:Say( nRow + 060, nCol + 373, Transform(aAux[nK][3], cPicPrcVen), oFont8)  //D2_PRCVEN
			  	 ::oPrint:Say( nRow + 060, nCol + 468, Transform(aAux[nK][5], cPicTotal), oFont8)  //D2_TOTAL			  	 
			  	 
				 nRow += 012		  	
		  	End If
		  	      
		  	//____________________________________________________________
		  	//                                                            | 
		  	// Controle de limite de impress�o                            |
		  	//____________________________________________________________|
		  	If  nRow >= 440          
		  	
		  	       ::lLimitePorPagina := .T.  
		  	       ::nCurrentPrint    := nK
		  	       
		  	       Exit  
		  	End If  
		   
	Next nK
	
	nRow := 510 
		
	
	::oPrint:Box( nRow , nCol + 297, nRow + 040, 565, "-4") 									// Caixa com o valor Total 
	
	::oPrint:Say( nRow + 020, nCol + 303, "VALOR TOTAL DA NOTA DE COBRAN�A", oFont12n)  		//
	::oPrint:Say( nRow + 035, nCol + 303, "R$ " + Transform(::nValorTotal, "@E 999,999.99"), oFont12n)  //
	
	::oPrint:Box( nRow + 058, nCol + 003, nRow + 240, 565, "-4") 															  // Caixa cujo conte�do ser� preenchido com as observa��es
	::oPrint:Say( nRow + 056, nCol + 006, "INFORMA��ES ADICIONAIS"												  ,	oFont12n) //
	::oPrint:Say( nRow + 073, nCol + 006, "Nosso site: http://www.tecnocryo.com.br/"							  , oFont8)	  // 
	::oPrint:Say( nRow + 083, nCol + 006, "E-mail: " + If(cFilAnt == "0201", "nfmg@tecnocryo.com.br", "contato@tecnocryo.com.br"), oFont8)	  // 
	::oPrint:Say( nRow + 093, nCol + 006, "Atendimento a clientes - Tel.: " + If(cFilAnt == "0201", "(31)3849-6491", "(27)3325-6533"), oFont8)	  // 
	::oPrint:Say( nRow + 103, nCol + 006, "OPERA��O N�O SUJEITA AO I.S.S DE ACORDO COM A LEI COMPLEMENTAR 116/03" , oFont8)	  // 
	
	::oPrint:Say( nRow + 123, nCol + 006, "VENCIMENTO: "+DTOC(::aDestinatario[::nAnt][4])+"   CLIENTE: "+SubStr(::aDestinatario[::nAnt][1],1,9)+"", oFont8)  															  //
	
	::oPrint:Say( nRow + 143, nCol + 006, ::aDestinatario[::nAnt, 05], oFont8) 	
	
	::oPrint:Box( nRow + 260, nCol + 003, nRow + 0300, 565, "-4") 								// �ltima caixa da p�gina 
	
	
	::oPrint:Box( nRow + 275, nCol + 003, nRow + 275, 565 , "-4")     		            		// Linha Divis�ria Horizontal   
	
	cMsg := "EM CASO DE LOCA��O, ATESTAMOS QUE OS DADOS ACIMA CONFEREM COM OS BENS CEDIDOS EM LOCA��O."
	
	::oPrint:Say( nRow + 273, nCol + 006, cMsg, oFont8)  										//
	
	::oPrint:Box( nRow + 275, nCol + 190, nRow + 300, nCol + 190 , "-4")                		// Linha Divis�ria Vertical
	::oPrint:Say( nRow + 290, nCol + 006, "DATA DO RECEBIMENTO:", oFont8)  			    		//
	::oPrint:Say( nRow + 290, nCol + 193, "IDENT./ASS. RECEBEDOR:", oFont8)  					//
	
	
	::oPrint:Box( nRow + 275, nCol + 380, nRow + 300, nCol + 380 , "-4")                		// Linha Divis�ria Vertical         	
	::oPrint:Say( nRow + 290, nCol + 383, "NOTA COBRAN�A. N�: "+::cDocumento+" ", oFont8)  		//
	
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
Method PopDest() Class TWFormularioDEB 
Local aArea     := GetArea()
Local cRecs     := "" 
Local cWorkArea := GetNextAlias()
Local cSql      := ""

	If Empty(::aRecSE1)
		Return
	EndIf

	For n := 1 To Len(::aRecSE1) 
		cRecs += cValToChar(::aRecSE1[n])
		
		If n != Len(::aRecSE1)
			cRecs += ","
		EndIf
	Next n		

	cSql := "SELECT E1_VENCREA, D2_SERIE, D2_DOC, A1_COD, A1_LOJA, B1_COD, B1_DESC, D2_PRCVEN, D2_QUANT, D2_TOTAL, F2_MENNOTA "
	cSql += "  FROM " + RetSqlName("SE1") + " SE1 (NOLOCK) "
	cSql += "  JOIN " + RetSqlName("SF2") + " SF2 (NOLOCK) ON F2_FILIAL = E1_FILIAL "
	cSql += "                          AND F2_DOC = E1_NUM "
	cSql += "						  AND F2_SERIE = E1_PREFIXO "
	cSql += "						  AND F2_CLIENTE = E1_CLIENTE "
	cSql += "						  AND F2_LOJA = E1_LOJA "
	cSql += "						  AND SF2.D_E_L_E_T_ != '*' "
	cSql += "  JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON A1_FILIAL = '" + xFilial("SA1") + "' "
	cSql += "                          AND A1_COD = F2_CLIENTE "
	cSql += "						  AND A1_LOJA = F2_LOJA "
	cSql += "						  AND SA1.D_E_L_E_T_ != '*' "
	cSql += "  JOIN " + RetSqlName("SD2") + " SD2 (NOLOCK) ON D2_FILIAL = F2_FILIAL "
	cSql += "                          AND D2_DOC = F2_DOC "
	cSql += "						  AND D2_SERIE = F2_SERIE "
	cSql += "						  AND D2_CLIENTE = F2_CLIENTE "
	cSql += "						  AND D2_LOJA = F2_LOJA "
	cSql += "						  AND SD2.D_E_L_E_T_ != '*' "
	cSql += "  JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON B1_FILIAL = '" + xFilial("SB1") + "' "
	cSql += "                          AND B1_COD = D2_COD "
	cSql += "						  AND SB1.D_E_L_E_T_ != '*' "
	cSql += " WHERE SE1.R_E_C_N_O_ IN (" + cRecs + ") "
	cSql += "   AND SE1.D_E_L_E_T_ != '*' "
	cSql += " ORDER BY D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_ITEM "
   
	TcQuery cSql New Alias (cWorkArea)
	
	While !(cWorkArea)->(Eof()) 
		nPos :=  aScan(::aDestinatario,{|x| x[2] == (cWorkArea)->(D2_DOC) })  
           
		If nPos  == 0
        	aAdd(::aDestinatario, {	(cWorkArea)->(A1_COD + A1_LOJA) ,;  
            						(cWorkArea)->(D2_DOC)			  ,;
									{{ (cWorkArea)->B1_COD   		  ,;
										(cWorkArea)->B1_DESC  		  ,;
										(cWorkArea)->D2_PRCVEN		  ,;
										(cWorkArea)->D2_QUANT		  ,;
										(cWorkArea)->D2_TOTAL         ;
									}} ,;
									STOD((cWorkArea)->E1_VENCREA) ,;
									AllTrim((cWorkArea)->F2_MENNOTA), ;
									(cWorkArea)->D2_SERIE ;
									}) 
		Else 
			aAdd(::aDestinatario[nPos][3], {	(cWorkArea)->B1_COD      ,;
												(cWorkArea)->B1_DESC     ,;
												(cWorkArea)->D2_PRCVEN   ,;
												(cWorkArea)->D2_QUANT	   ,;
												(cWorkArea)->D2_TOTAL     ;
											}) 
		EndIf      

		(cWorkArea)->(DbSkip())
	EndDo
	
	DbCloseArea(cWorkArea)

	RestArea(aArea)	
Return Self
/**/
Method ObtemDadosNF() Class TWFormularioDEB
Local cWorkArea := GetNextAlias()
Local cSQL		:= ""	               
Local cQuebra   := Chr(13) + Chr(10)
	
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
	cSQL += "D2_SERIE 			 ,"  	
	cSQL += "E1_VENCREA			 ,"  
	cSQL += "F2_MENNOTA			  "  	
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
            	                          STOD((cWorkArea)->E1_VENCREA) ,;
                                          AllTrim((cWorkArea)->F2_MENNOTA), ;
                                          (cWorkArea)->D2_SERIE ;
            	                       }) 
           Else 
				 aAdd(::aDestinatario[nPos][3], {   					    ;
                								  (cWorkArea)->B1_COD      ,;
            	  						          (cWorkArea)->B1_DESC     ,;
            	  						          (cWorkArea)->D2_PRCVEN   ,;
            	  						          (cWorkArea)->D2_QUANT	   ,;
            	  						          (cWorkArea)->D2_TOTAL     ;
            	                               }) 
           End If                      
          
           (cWorkArea)->(dbSkip())
    End Do
    
    DbCloseArea(cWorkArea)
Return
//
Method Enviar() Class TWFormularioDEB
Local cServidor   := AllTrim(GetMv("MV_RELSERV"))
Local cConta      := AllTrim(GetMv("MV_RELACNT"))
Local cContaSenha := AllTrim(GetMv("MV_RELPSW")) 
Local cUsuarioAut := AllTrim(GetMv("MV_RELAUSR"))
Local cMsg        := ""
Local cSenhaAut   := AllTrim(GetMv("MV_RELAPSW"))
Local cDe         := AllTrim(GetMv("MV_RELFROM"))
Local lAut        := GetMv("MV_RELAUTH")
Local lSSL        := GetMv("MV_RELSSL")
Local lTSL        := GetMv("MV_RELTLS")
Local nTimeOut    := GetMv("MV_RELTIME")
Local nPorta      := 0
Local oGerencia, oEmail
Local nErro, nPosPorta

	::lEnviado := .F.

	cUsuarioAut := If(Empty(cUsuarioAut), cConta, cUsuarioAut)
	cSenhaAut   := If(Empty(cSenhaAut), cContaSenha, cSenhaAut)
	cDe         := If(Empty(cDe), "workflow@protheus.com.br", cDe)
	nTimeOut    := If(Empty(nTimeOut), 120, nTimeOut)
	nPosPorta   := At(":", cServidor)

	If nPosPorta > 0
		nPorta    := Val(AllTrim(SubStr(cServidor, nPosPorta + 1)))
		cServidor := SubStr(cServidor, 1, nPosPorta - 1)
	End If

	oGerencia := TMailManager():New()

	If Empty(nPorta)
		Do Case
			Case lTSL
				nPorta := 587
			Case !lTSL .And. lSSL
				nPorta := 465
			OtherWise
				nPorta := 25
	    End Case
	End If
	
	If lTSL
		oGerencia:SetUseTLS(lTSL)
	EndIf
	
	If lSSL
		oGerencia:SetUseSSL(lSSL)	
	End If

	oGerencia:Init("", cServidor, cConta, cContaSenha, 0, nPorta)
	oGerencia:SetSmtpTimeOut(nTimeOut)

	ConOut('Conectando ao SMTP')

	Begin Sequence
		nErro := oGerencia:SmtpConnect()
		If nErro <> 0
			ConOut("ERRO: " + oGerencia:GetErrorString(nErro))
			Break			
		End If

		If lAut
			ConOut('Autenticando no SMTP')	
			
			nErro := oGerencia:SMTPAuth(cUsuarioAut, cSenhaAut)
			If nErro <> 0
				ConOut("ERRO:" + oGerencia:GetErrorString(nErro))
				Break
			Endif
		End If

		oEmail := TMailMessage():New()

		oEmail:Clear()
		oEmail:cFrom    := cDe
		oEmail:cTo      := Alltrim(SA1->A1_EMAIL)
		oEmail:cCc      := If(FwCodFil() == "0201", "nfmg@tecnocryo.com.br", "")
		oEmail:cSubject := SF2->F2_SERIE + " " + SF2->F2_DOC

		cMsg := "A<br/>"
		cMsg += AllTrim(SA1->A1_NOME) + "<br/><br/>"
		cMsg += "Prezado, segue nota de cobran�a " + SF2->F2_SERIE + " " + SF2->F2_DOC
		cMsg += " com vencimento em " + Dtoc(SE1->E1_VENCTO) + ".<br/><br/>"
		cMsg += "Estamos a disposi��o para maiores esclarecimentos.<br/><br/>"
		cMsg += "Atenciosamente,<br/>"

		oEmail:cBody := cMsg
	
		nErro := oEmail:AttachFile(::cPathPDF + ::cFile + ".pdf")
		If nErro <> 0
			ConOut("Erro ao atachar o arquivo")
			Break			
		End If			

		nErro := oEmail:Send(oGerencia)
		If nErro <> 0
			ConOut("ERRO:" + oGerencia:GetErrorString(nErro))
		Else
			::lEnviado := .T.
		Endif		
	End Sequence

	ConOut("Desconectando do SMTP")

	oGerencia:SMTPDisconnect()	  
Return(::lEnviado)