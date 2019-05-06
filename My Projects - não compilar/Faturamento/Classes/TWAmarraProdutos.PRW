#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "FONT.CH"
#INCLUDE "MSOBJECT.CH" 
#include "TOTVS.CH"     

Static oGetDupl := Nil

Class TWAmarraProdutos From LongClassName
	                             
	Data oDlg						 // Dialog Principal   
	
	Data cTitulo
	Data cCampo 
	Data cMacara
	Data nTamanho   
	Data cValidacao  
	Data cF3
	Data nOpc
	
	Data oGetDados
	Data aHeader
	Data aCols 
	Data aDicionario 
	Data aButtons
	
	Method New() Constructor 		  // Metodo construtor  
    Method MapeiaCamposGetDados()     // Gerencia os campos a serem criados na MsNewGetDados
    Method CarregaPropiedadeJanela()  // 
    Method ValidaInclusaoProduto()	  //
    Method DefinirConsultaDeProduto() //
    Method PesquisaProduto()		  //
    Method GetDadosVazio()
    Method Show()					  // Exibe a janela 	
EndClass 

Method New() Class TWAmarraProdutos

	::oDlg 		 := Nil 
	::oGetDados	 := Nil  
	
	::cTitulo	 := ""
	::cCampo 	 := ""
	::cMacara    := ""
	::nTamanho   := "" 
	::cValidacao := ""
	::cF3		 := ""
	::nOpc		 := GD_INSERT+GD_UPDATE+GD_DELETE
	
    ::aHeader	 := {}
	::aCols		 := {}
	::aDicionario:= {} 
	::aButtons	 := {""}  
	
	//Aadd( ::aButtons, {"HISTORIC", {|| ::PesquisaProduto() },"","Consultar Produto",{|| .T.}} ) 	 
	
Return      
       
 
 
       
Method Show() Class TWAmarraProdutos

	Local bOK	    := {|| iif( VldTudoOk(), ::oDlg:End(), )   }     
	Local bCancelar := {|| ::oDlg:End() }
	Local lTudoOk 	:= .F.         
    
	Local aButtons	:= {}   
	                                           
	
	aAdd( aButtons, {"HISTORIC", {|| ::DefinirConsultaDeProduto()}, "","Consultar Produto",{|| .T.}} )
		                       
	DEFINE MSDIALOG ::oDlg TITLE "Produto Interno vs Produto Fornecedor" FROM 000,000 TO 320,1000 PIXEL  //STYLE FRAME 128                                             
	
	::aHeader    := ::MapeiaCamposGetDados()
	::oGetDados  := MSNewGetDados():New(000,000, 160, 502, ::nOpc,'AlwaysTrue()','U_VldTOK','',{"B1_COD"},,9999,,,,::oDlg ,::aHeader,{},{||}) 	  	
	
	oGetDupl	 := ::oGetDados     
	
	EnchoiceBar(::oDlg, bOK, bCancelar,,@aButtons)
	
	ACTIVATE MSDIALOG ::oDlg
				

Return    
       

Static Function VldTudoOk()
	
	Local lTudoOK 	:= .T.
	Local nTamanho  := 0
	Local nK 		:= 0
	
	
	For nK := 1 To Len(oGetDupl:aCols)
		  
		  nTamanho := Len(oGetDupl:aCols[nK])
		   	
		  If !oGetDupl:aCols[nK][nTamanho]   
		  
			   If  Empty(oGetDupl:aCols[nK][1]) .Or. Empty(oGetDupl:aCols[nK][3])
			  	   
			  	    lTudoOK	:= .F.	
			   Endif 		      
		  Endif 		     
	Next nK
	    
	
	If  lTudoOK
		
		Processa({||GrvProds()}, "Associando Produtos", "Gravando os dados, aguarde...")  
	Else
		Aviso("Atenção","Preencha todos os campos para finalizar o processo" ,{"OK"},1) 	
	Endif 
	
Return  lTudoOK



Method CarregaPropiedadeJanela() Class TWAmarraProdutos
            
  	//__________________________________________________
  	//                                                  | 
  	//Campos que formam o cabeçalho da MsNewGetDados    | 
  	//__________________________________________________|             
  	                                                       	
    Aadd(::aDicionario,{"B1_COD"  , .T.,"Prod.(Aplicado)", 015	, "U_VldProd()"  	,"SB1" 	}) 
  	Aadd(::aDicionario,{"B1_DESC" , .T.,"Desc." 	     , 050	, "" 	 			,""		}) 	
  	Aadd(::aDicionario,{"B1_COD"  , .T.,"Prod.(Cob.Loc.)", 015	, "U_VldProd()" 	,"SB1"	}) 
  	Aadd(::aDicionario,{"PRDEXT"  , "Desc."			     , "@!"	, 015 				,"","" 	}) 
  	                              
Return  



Method MapeiaCamposGetDados() Class TWAmarraProdutos
	
	Local aAux := {}
	Local nK   := 0
    
    //______________________________________________________________________
    //                                                                      | 
    // Cria coluna(s) que representarão a legenda                           | 
    //______________________________________________________________________|
    
    SX3->(dbSetOrder(2))
    
	For nX := 1 To Len (::aDicionario)
		   
			   //______________________________________________________________________
	    	   //                                                                      | 
	    	   // Posiciona sobre o campo informado a fim de obter suas configurações  | 
	    	   //                                                                      |
	    	   //______________________________________________________________________|
			   
			   If SX3->(dbSeek(::aDicionario[nX][1]))
			                                       
			          //_______________________________________________________________
			          //                                                               | 
			          // Permite a personalização dos campos padrões                   |
			          //                                                               | 
			          //_______________________________________________________________|
			          
			          ::cTitulo  := TRIM(X3Titulo()) 
					  ::nTamanho := SX3->X3_TAMANHO 
			                
			          //_______________________________________________________________
			          //                                                               |
			          // Tratamento específico para campos personalizados			   |                                             
			          //                                                               |
			          //_______________________________________________________________|
			          
			          If ::aDicionario[nX][2]
			          		
			          	    ::cTitulo    := iif( !Empty(::aDicionario[nX][3]) , ::aDicionario[nX][3], TRIM(x3Titulo())	)
			          		::nTamanho   := iif( ::aDicionario[nX][4] > 0		, ::aDicionario[nX][4], SX3->X3_TAMANHO )
			          		::cValidacao := iif( !Empty(::aDicionario[nX][5])   , ::aDicionario[nX][5], SX3->X3_VALID 	) 
   							::cF3        := iif( !Empty(::aDicionario[nX][6])   , ::aDicionario[nX][6], SX3->X3_F3  	)
			          Endif 
					  
					  aAdd(aAux,{  ::cTitulo		,;
								   SX3->X3_CAMPO	,;	
								   SX3->X3_PICTURE	,;
								   ::nTamanho		,;
								   SX3->X3_DECIMAL	,;
								   ::cValidacao		,;
								   SX3->X3_USADO	,;
								   SX3->X3_TIPO		,;	
								   ::cF3			,;
								   SX3->X3_CONTEXT	,;
								   SX3->X3_CBOX		,;
								   SX3->X3_RELACAO	,;
								   ".T."			})				
	            
	           Else    
	                 //===============================================================================|
	                 // Campos personalizados a serem utilizados no cabeçalho da Classe MsNewGetDados |
	                 //===============================================================================|
					 ::cCampo  	  := ::aDicionario[nX][1]
	                 ::cTitulo    := ::aDicionario[nX][2]
					 ::cMacara    := ::aDicionario[nX][3]
					 ::nTamanho   := ::aDicionario[nX][4]  
					 ::cValidacao := ::aDicionario[nX][5]  
					 ::cF3		  := ::aDicionario[nX][6]   

					
	           	     Aadd(aAux,{ ""+::cTitulo+"", ::cCampo, ::cMacara, ::nTamanho , , ::cValidacao, , , ::cF3,"V"})				
	           Endif
	Next nX 
    
    
    
 Return ::aDicionario := aClone(aAux) 


    
Method DefinirConsultaDeProduto() Class TWAmarraProdutos
	                   
	Local cSQL	   := ""
	Local aPergs   := {}
	Local aRet     := {} 
	Local aProcPrd := {"01=Prod.(Aplicado)","02=Prod.(Cob.Loc.)", "03=Ambos"}
	Local lRet     := .F. 

	aAdd(aPergs,{2,"Origem do Produto", 						   , aProcPrd,70 , "", .F.})
	aAdd(aPergs,{1,"Produto De" 	  , Space(TamSX3("B1_COD")[1]) ,"", "", "SB1", "", 0,.F.})      
	aAdd(aPergs,{1,"Produto Até"	  , Space(TamSX3("B1_COD")[1]) ,"", "", "SB1", "", 0,.F.}) 
	
	
	If ParamBox(aPergs ,"",aRet)      
		  
		  cSQL += " SELECT								   "
		  cSQL += " ZZ1.ZZ1_PRDINT CAMPO01		  		 , "
		  cSQL += " ZZ1.ZZ1_PRDEXT CAMPO03		  		 , "
		  cSQL += " ZZ1.R_E_C_N_O_ ZZ1REC   			   "  
		  cSQL += " FROM " + RetSqlName("ZZ1") +" AS ZZ1   "
		  cSQL += "  WHERE ZZ1.D_E_L_E_T_ ='' 			   " 
		  
		  If MV_PAR01 == "01"
		       
		       If !Empty(MV_PAR03,2)
		                                               
		       		cSQL += " AND (ZZ1_PRDINT BETWEEN  '"+MV_PAR02+"' AND '"+MV_PAR03+"' ) " 
		       Endif
		        
		       cSQL += " ORDER BY ZZ1_PRDINT "
		       
		       
		  Elseif MV_PAR01 == "02" 
		       
		       If !Empty(MV_PAR03,2)
		       	    
		       	    cSQL += " AND (ZZ1_PRDEXT BETWEEN  '"+MV_PAR02+"' AND '"+MV_PAR03+"' ) " 
		       Endif
		       
		       cSQL += " ORDER BY ZZ1_PRDEXT"
		  Else 
		  	
		  	   If !Empty(MV_PAR02,2) .And.  !Empty(MV_PAR03,2)
		       		
		       		 cSQL += " AND (ZZ1_PRDINT BETWEEN  '"+MV_PAR02+"' AND '"+MV_PAR03+"'  OR  ZZ1_PRDEXT BETWEEN  '"+MV_PAR02+"' AND '"+MV_PAR03+"'   )"
		       Endif                                          
		       
		  	   cSQL += " ORDER BY ZZ1_PRDINT "	
		  Endif 
		  
		  ::PesquisaProduto(cSQL)
	EndIf
		                        
Return 



Method PesquisaProduto(cQuery) Class TWAmarraProdutos
    
    Local cWorkArea := GetNextAlias()               
	//==============================================
	                     
	Local nTam      := 0
	Local nX     	:= 0                            
	
	//============================================== 
	Local aAux	    := {}  
	                   
	//==============================================                           
    
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cWorkArea, .T., .F.)
	
	Count To nTotal 
	                  
	//==========================================|
	// Posiciona no primeiro registro da tabela |
	//==========================================|
	(cWorkArea)->(dbGotop())
	
	ProcRegua(nTotal)
	
	::oGetDados:aCols := {}
    
    (cWorkArea)->(dbGoTop()) 
         
	While (cWorkArea)->(!Eof())
	      
	      IncProc(nTotal)
	      
	      aAux := {}                                   
	      
	      //_________________________________________________________________________________________
	      //                                                                                         |  
	      // Posiciona sobre o Álias corrente                                                        | 
	      //_________________________________________________________________________________________| 
	      
		  Aadd(aAux, (cWorkArea)->(CAMPO01)) 
		  Aadd(aAux, Posicione("SB1", 1, xFilial("SB1") + PADR((cWorkArea)->CAMPO01,TAMSX3("B1_COD")[1]),"B1_DESC")) 
		  Aadd(aAux, (cWorkArea)->(CAMPO03))
		  Aadd(aAux, Posicione("SB1", 1, xFilial("SB1") + PADR((cWorkArea)->CAMPO03,TAMSX3("B1_COD")[1]),"B1_DESC")) 
		  
		  //===========================================|
		  // Valor responsável pela seleção do registro| 	
		  //===========================================|
		  Aadd(aAux, (cWorkArea)->(ZZ1REC)) 	
		  
		  //===========================================|
		  // Coluna adicional do aCols.				   | 	
		  //===========================================|
		  Aadd(aAux,.F.) 
		   
		  Aadd(::oGetDados:aCols,aClone(aAux))
		   
		  (cWorkArea)->(dbSkip())	 
	EndDo
	                   
	(cWorkArea)->(dbCloseArea())
	
	::oGetDados:oBrowse:Refresh() 
	
	oGetDupl := ::oGetDados     
	
	//================================================|
	// aCols Vazio                                    | 
	//================================================|
	If Empty(::oGetDados:aCols)      
	
		 ::GetDadosVazio(::oGetDados)
	Endif
	
	
Return
//________________________________________________________________________________________________              



Method GetDadosVazio(oGetDados) Class TWAmarraProdutos

	Local cCampo := ""
	Local nX 	 := 0   
	
	//==========================================================================================|
	// Zera o aCols  																			|
	//==========================================================================================| 
	oGetDados:aCols := {}
    //==========================================================================================|
	// Cria uma nova linha para o aCols															|
	//==========================================================================================| 
    Aadd(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))     
    
    For nX := 1 To Len(oGetDados:aHeader)
    
      	   cCampo := oGetDados:aHeader[nX][2]  
           
      	   If cCampo == "OK" .Or.   cCampo == "COL01"   
      	       oGetDados:aCols[1][nX] := 'BR_AMARELO'
      	   Else    
      	       If oGetDados:aHeader[1][8] =="N"
	      	       oGetDados:aCols[1][nX] := 0
	      	   Elseif oGetDados:aHeader[nX][8] =="D"
			   	   oGetDados:aCols[1][nX] := CTOD("")      	  
	      	   Elseif oGetDados:aHeader[nX][8] =="C"
	      	 	   oGetDados:aCols[1][nX] := Space(TamSx3(cCampo)[1])
	      	   Endif 
	      Endif    
	Next nX

  	oGetDados:aCols[1][Len(oGetDados:aHeader)+1] := .F.
	
	//==========================================================================================|
	// Atualiza o objeto                                                                        | 
	//==========================================================================================|   	
  	oGetDados:oBrowse:Refresh()

Return (Nil) 



User Function  VldProd()
    
    Local cWorkArea := GetNextAlias()
	Local cQuery    := ""
	Local cProduto  := "" 
    	                                        
    Local nLin 	   := oGetDupl:oBrowse:nAt  
    Local nCol     := oGetDupl:oBrowse:nColPos	       
    Local nTamanho := 0
    Local nK	   := 0
    
    Local lRet 	   := .T.
	
	If ExistCpo("SB1", M->B1_COD) 
		  
		  If Len(oGetDupl:aCols) > 1 
		  		   
		  	    For nK := 1 To Len(oGetDupl:aCols)
		  	           
		  	    	   nTamanho := Len(oGetDupl:aCols[nK])
		  	    	   
		  	    	   If !oGetDupl:aCols[nK][nTamanho]
		  	    	   
			  	    	    If  Alltrim(oGetDupl:aCols[nK][1])== Alltrim(M->B1_COD) .Or. Alltrim(oGetDupl:aCols[nK][3])== Alltrim(M->B1_COD) 
			  	    	        
			  	    	        Aviso("Atenção","O Produto "+Alltrim(M->B1_COD)+" já está vinculado a outro Produto" ,{"OK"},1) 
						  		lRet := .F.
			  	    	    Endif 
		  	    	   Endif 
		  	    Next nK
		  	        
		  	    	
		  	    
		  Else 
		  		
		  	   If  !oGetDupl:aCols[1][Len(oGetDupl:aCols[1])]
			  		
			  		If !Empty(M->B1_COD) 
			  		
				  		 oGetDupl:aCols[nLin][nCol] := M->B1_COD
				  		 
				  		 If Alltrim(oGetDupl:aCols[nLin][1]) == Alltrim(oGetDupl:aCols[nLin][3]) .And. !oGetDupl:aCols[nLin][Len(oGetDupl:aCols[1])]
					  		
					  		   Aviso("Atenção","O Produto "+Alltrim(M->B1_COD)+" já está vinculado a outro Produto na " ,{"OK"},1) 
							   lRet := .F.
					  	  Endif
					  	 
			  		Endif 
		  	   Endif 
		  Endif 
		  
		  
		  //__________________________________________________________________________________________
		  //                                                                                          | 
		  // A descrição dos campos será atualizada apenas em caso da validação estar correta.        |
		  //__________________________________________________________________________________________|
		  
		  If lRet
		       
		        //__________________________________________________________________________________________
		        //                                                                                          | 
		        // Impede o lançamento de um produto que já esteja associado com outro                      |
		        //__________________________________________________________________________________________|
		        
		        cQuery  += " SELECT ZZ1.R_E_C_N_O_ ZZ1REC FROM "+ RetSqlName("ZZ1") +" AS ZZ1 	" 
				cQuery  += " WHERE ZZ1.D_E_L_E_T_ = '' 											"
  				cQuery  += " AND ZZ1.ZZ1_FILIAL   = '"+xFilial("ZZ1")+"' 						"  
  				cQuery  += " AND ( ZZ1.ZZ1_PRDINT = '"+M->B1_COD+"' 							"  
  				cQuery  += " OR    ZZ1.ZZ1_PRDEXT = '"+M->B1_COD+"') 							" 
  				 
  	            dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cWorkArea, .T., .F. )
		        
		        If  (cWorkArea)->(!Eof())
		             
		               MsgAlert("Este produto já está cadastrado !","Atenção") 
		        	   lRet := .F.   
		        	   
		        	   //________________________________________________________________________________________________
				       //                                                                                                | 
				       // Fecha a área de trabalho ativa                                                                 |
					   //________________________________________________________________________________________________|
				
					   (cWorkArea)->(dbCloseArea()) 
		        	   
		        Else 
			         
			          //__________________________________________________________________________________________
		              //                                                                                          | 
		        	  // Identifica a coluna que cujo valor foi informado                                         | 
		        	  //__________________________________________________________________________________________|
			          If oGetDupl:oBrowse:nColPos == 1
						
				          oGetDupl:aCols[nLin][GDFieldPos('B1_DESC')] := SB1->B1_DESC
				      Else
					      oGetDupl:aCols[nLin][GDFieldPos('PRDEXT')]  := SB1->B1_DESC
				      Endif
				Endif
				
		  Endif
	Else
		lRet := .F.
	Endif 
	
	
Return lRet  
       


Static Function GrvProds()

	//________________________________________________
	
	Local cWorkArea := GetNextAlias()
	Local cQuery    := ""
	Local cProdInt  := "" 
	Local cProdExt  := ""                            
	
	//________________________________________________
	Local nTamanho  := 0 
	Local nK 		:= 0 
	
            
    ZZ1->(dbSetOrder(1))
    
    For nK := 1 To Len(oGetDupl:aCols)
			  
			nTamanho := Len(oGetDupl:aCols[nK])
			
			If nTamanho == Len(oGetDupl:aHeader) + 1
			
				  If !oGetDupl:aCols[nK][nTamanho]  
						  
						ZZ1->(RecLock("ZZ1", .T.))	  
							      
							ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
							ZZ1->ZZ1_PRDINT := oGetDupl:aCols[nK][1]
							ZZ1->ZZ1_PRDEXT := oGetDupl:aCols[nK][3] 	   		 
							  
						ZZ1->(MSUnlock())
			      Endif 
	      	Else  
	      		
	      		  //________________________________________________________________________________________________
			      //                                                                                                | 
			      // Deleta/Altera,respectivamente, o registro atualmente posicionado                               | 
			      //________________________________________________________________________________________________|
			           
			      ZZ1->(dbGoto(oGetDupl:aCols[nK][nTamanho-1]))
			      
			      ZZ1->(RecLock("ZZ1", .F.))
				      
					   If oGetDupl:aCols[nK][nTamanho]  
					      
						   ZZ1->(dbDelete())         
					   Else                  
			      	       ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
						   ZZ1->ZZ1_PRDINT := oGetDupl:aCols[nK][1]
						   ZZ1->ZZ1_PRDEXT := oGetDupl:aCols[nK][3] 	   		 
					   Endif 
	      		  
	      		  ZZ1->(MSUnLock())	
	      	Endif 	
	Next nK
			
Return