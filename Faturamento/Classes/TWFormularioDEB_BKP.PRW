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
Method ConfigLayoutCabecalho()  // Determina as configurações do Layout  
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

Method Init() Class TWFormularioDEB    
Return 

Method ConfigLayoutCabecalho()  Class TWFormularioDEB

	Local oFont8
	Local oFont12n
	Local oFont12In
	Local oFont11n

	Local nRow := 0 	
	Local nCol := 0 

	oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11n := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10n := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12n := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12In:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)

	::oPrint:StartPage()    // Inicia uma nova página	

	nRow := 040
	nCol := 030

	::oPrint:SayBitmap(nRow, nCol, ::cLogo, 120, 040)

	::oPrint:Box( nRow + 015 , 475, nRow + 050		 , 565, "-4")    
	::oPrint:Say( nRow + 024 , 478, "NOTA COBRANÇA"  , oFont12n) 
	::oPrint:Say( nRow + 040 , 494.74, ::cDocumento 	 , oFont12n) 

	//____________________________________________________________________________________________
	//                                                                                            |  
	// Dados ligados a identificação da Empresa                                                   |
	//____________________________________________________________________________________________|

	::oPrint:Say(nRow 	   , nCol + 125, SM0->M0_NOMECOM, oFont11n)  

	//	::oPrint:Say(nRow + 015, nCol + 110, cFilAnt +" - "+ FWFilName (cEmpAnt, cFilAnt )					, oFont12n)  
	::oPrint:Say(nRow + 012, nCol + 125, "ENDEREÇO: "+SM0->M0_ENDENT+""									, oFont11n)  
	::oPrint:Say(nRow + 024, nCol + 125, "BAIRRO/DISTRITO: "+SM0->M0_BAIRENT+""							, oFont11n)  	 
	::oPrint:Say(nRow + 036, nCol + 125, "MUNICIPIO: "+Alltrim(SM0->M0_CIDENT)+" "						, oFont11n) 
	::oPrint:Say(nRow + 048, nCol + 125, "UF: "+Alltrim(SM0->M0_ESTENT)+""								, oFont11n)  			 		
	::oPrint:Say(nRow + 060, nCol + 125, "CEP: "+Transform(Alltrim(SM0->M0_CEPENT),"@R 99.999-999")+""	, oFont11n)  		


	//____________________________________________________________________________________________
	//                                                                                            | 
	// NOTA DE COBRANÇA | Nº                                                                      |
	//____________________________________________________________________________________________|



	//____________________________________________________________________________________________
	//                                                                                            | 
	// CNPJ                                                                      				  |
	//____________________________________________________________________________________________|

	::oPrint:Box( nRow + 105, 252, 200, 465												  , "-4")       // Caixa Principal
	::oPrint:Say( nRow + 118, 255, "CNPJ"												  , oFont12n)  	//
	::oPrint:Say( nRow + 131, 255, Transform(Alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99"), oFont8)   	//


	::oPrint:Box( nRow + 132, 252, nRow + 132, 465, "-4") 												// Linha Divisória  
	::oPrint:Say( nRow + 145, 255, "INSCRIÇÃO ESTADUAL"	, oFont12n) 									// 
	::oPrint:Say( nRow + 158, 255, SM0->M0_INSC		, oFont8) 

	SF2->(DbSetOrder(1))
	SF2->(DbSeek(xFilial("SF2") + ::cDocumento + ::aDestinatario[::nAnt,06]))

	//____________________________________________________________________________________________
	//                                                                                            | 
	// EMISSÃO                                                                      			  |
	//____________________________________________________________________________________________|	

	::oPrint:Box( nRow + 105, 475, 172		 , 565, "-4") 
	::oPrint:Say( nRow + 113, 478, "EMISSÃO" , oFont12n) 

	::oPrint:Box( nRow + 118, 475, nRow + 118, 565 , "-4") 
	::oPrint:Say( nRow + 130, 478, DToC(SF2->F2_EMISSAO) , oFont8) 	

	//____________________________________________________________________________________________
	//                                                                                            | 
	// DESTINATÁRIO                                                                      		  |
	//____________________________________________________________________________________________|	

	nRow := 210

	::oPrint:Say(nRow - 005	, nCol, "DESTINATÁRIO"	, oFont12n)   

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + (SF2->F2_CLIENTE + SF2->F2_LOJA)))

	::oPrint:Box( nRow 		, nCol		, nRow + 085			, 565, "-4")   				// Caixa Principal   
	::oPrint:Say(nRow + 013	, nCol + 003, "NOME/RAZÃO SOCIAL" 	, oFont12n)  				// 
	::oPrint:Say(nRow + 028	, nCol + 003, SA1->A1_NOME , oFont8  )  						// 


	::oPrint:Box( nRow 	 	, 415, nRow + 030, 565 	, "-4")  						   		// Linha divisória Vertical 
	::oPrint:Say( nRow + 013, 418, "CPF/CNPJ"		, oFont12n)  		 					// 
	::oPrint:Say( nRow + 028, 418, Transform( Alltrim(SA1->A1_CGC), "@R 99.999.999/9999-99" ), oFont12n)     

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
	::oPrint:Say( nRow + 043 , nCol + 003, "ENDEREÇO"	, oFont12n)  						// 
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
	Local cPicTotal  := "", nTamStr

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
	::oPrint:Say( nRow + 035, nCol + 303, "R$ " + Transform(::nValorTotal, "@E 999,999.99"), oFont12n)  //

	::oPrint:Box( nRow + 058, nCol + 003, nRow + 240, 565, "-4") 															  // Caixa cujo conteúdo será preenchido com as observações
	::oPrint:Say( nRow + 056, nCol + 006, "INFORMAÇÕES ADICIONAIS"												  ,	oFont12n) //
	::oPrint:Say( nRow + 073, nCol + 006, "Nosso site: http://www.tecnocryo.com.br/"							  , oFont8)	  // 
	::oPrint:Say( nRow + 083, nCol + 006, "E-mail: " + If(cFilAnt == "0201", "nfmg@tecnocryo.com.br", "contato@tecnocryo.com.br"), oFont8)	  // 
	::oPrint:Say( nRow + 093, nCol + 006, "Atendimento a clientes - Tel.: " + If(cFilAnt == "0201", "(31)3849-6491", "(27)3325-6533"), oFont8)	  // 
	::oPrint:Say( nRow + 103, nCol + 006, "OPERAÇÃO NÃO SUJEITA AO I.S.S DE ACORDO COM A LEI COMPLEMENTAR 116/03" , oFont8)	  // 

	::oPrint:Say( nRow + 123, nCol + 006, "VENCIMENTO: "+DTOC(::aDestinatario[::nAnt][4])+"   CLIENTE: "+SubStr(::aDestinatario[::nAnt][1],1,9)+"", oFont8)  															  //

	//	::oPrint:Say( nRow + 143, nCol + 006, ::aDestinatario[::nAnt, 05], oFont8) 	

	cMsgAdic := ::aDestinatario[::nAnt, 05]
	nTam	 := 120
	nStr	 := 1
	nRow 	 += 143
	nOldRow	 := nRow

	IF Len( cMsgAdic ) > nTam

		WHILE nStr < Len( cMsgAdic )

			nTamStr	:= nTam
			lTam120 := Empty( SubStr( cMsgAdic, nTamStr + 1,  1  ) ) .OR. Empty( SubStr( cMsgAdic, nTamStr,  1  ) )

			IF ! lTam120
				nTamStr	:= rAT( " ", SubStr( cMsgAdic, nStr, nTamStr  ) )
				IF nTamStr < 1 
					nTamStr := LEN( cMsgAdic )
				ENDIF
				nTamStr += 1
			ENDIF 


			::oPrint:Say( nRow, nCol + 006, AllTrim( SubStr( cMsgAdic, nStr, nTamStr ) ), oFont8) 	
			nRow += 15
			
			cMsgAdic := SubStr( cMsgAdic, nTamStr )
			
		ENDDO

	ELSE
		::oPrint:Say( nRow, nCol + 006, ::aDestinatario[::nAnt, 05], oFont8) 	
	ENDIF

	nRow := nOldRow
	
	::oPrint:Box( nRow + 105, nCol + 003, nRow + 0180, 565, "-4") 								// Última caixa da página 

	::oPrint:Box( nRow + 125, nCol + 003, nRow + 180, 565 , "-4")     		            		// Linha Divisória Horizontal   

	cMsg := "EM CASO DE LOCAÇÃO, ATESTAMOS QUE OS DADOS ACIMA CONFEREM COM OS BENS CEDIDOS EM LOCAÇÃO."

	::oPrint:Say( nRow + 118, nCol + 006, cMsg, oFont8)  										//

	::oPrint:Say( nRow + 133, nCol + 006, "DATA DO RECEBIMENTO:", oFont8)  			    		//

	::oPrint:Box( nRow + 125, nCol + 190, nRow + 0180, nCol + 190 , "-4")                		// Linha Divisória Vertical
	::oPrint:Say( nRow + 133, nCol + 193, "IDENT./ASS. RECEBEDOR:", oFont8)  					//


	::oPrint:Box( nRow + 125, nCol + 380, nRow + 0180, nCol + 380 , "-4")                		// Linha Divisória Vertical         	
	::oPrint:Say( nRow + 133, nCol + 383, "NOTA COBRANÇA. Nº: "+::cDocumento+" ", oFont8)  		//

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
	Local n

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

	(cWorkArea)-> ( DbCloseArea() )

	RestArea(aArea)	
	Return Self
	/**/
Method ObtemDadosNF() Class TWFormularioDEB
	Local cWorkArea := GetNextAlias()
	Local cSQL		:= ""	               
	//	Local cQuebra   := Chr(13) + Chr(10)

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

	(cWorkArea)-> ( DbCloseArea() )

Return

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
		cMsg += "Prezado, segue nota de cobrança " + SF2->F2_SERIE + " " + SF2->F2_DOC
		cMsg += " com vencimento em " + Dtoc(SE1->E1_VENCTO) + ".<br/><br/>"
		cMsg += "Estamos a disposição para maiores esclarecimentos.<br/><br/>"
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