#INCLUDE "RWMAKE.CH"   
#INCLUDE "PROTHEUS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FINRE001  ³ Autor ³ TIAGO ROSSINI        	³ Data ³ 08/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCARIO COM CODIGO DE BARRAS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
OBSERVAÇÃO:
Segue abaixo trecho do email do Banestes aprovando o layout do boleto.
///////////*******************************
titulocobranca <titulocobranca@banestes.com.br>
Para: Henan Soares Ferreira <henan.ferreira@totvs.com.br>
Cc: Andre Mombrine Lima <andrem@totvs.com.br>, Tecnocryo@tecnocryo.com.br, sandro.costa@totvs.com.br, denni.martins@totvs.com.br, elielmopinheiro@banestes.com.br
Re: Boletos e Arquivo de Remessa

Prezados, bom dia! 

Comunicamos que os boletos enviados para homologação no dia 24/07/2013, referentes à conta 20.644.894,  não apresentaram erros em sua construção. 
Os boletos estão validados e liberados para emissão a partir desta data. 

Atenciosamente, 

Gustavo P. da Silva 
GEARC - Gerência de Arrecadação e Cobrança Bancária
COCOB - Coordenadoria de Cobrança bancária
Telefones: (27) 3383-1337 / 1338 /1340/ 1343
///////////*******************************
/*/ 

STATIC nTipoBarra     := 1                                                        
STATIC nTipoRNumerica := 2
STATIC nTipoNNumero   := 3

User Function TECRE001(aTitulos)

	LOCAL	aPergs := {}

	PRIVATE lExec    	:= .F.
	PRIVATE cIndexName	:= ''
	PRIVATE cIndexKey 	:= ''
	PRIVATE cFilter   	:= ''   
	//	PRIVATE nJurMes   	:= GetMV("MV_YJURMES")
	//	PRIVATE nFatJurDia  := (nJurMes/30)/100
	Private cIndexName	:= ''
	Private cIndexKey	:= ''
	Private cFilter		:= ''
	Private _cLinDig 	:= ''
	Private _cCodBar 	:=''
	Private _cBanco 	:= ""
	Private _cMoeda 	:= "9"
	Private _cTipo 		:= ""
	Private cConvBB 	:= SA6->A6_NUMBCO //"2113640"
	Private cMark 		:= GetMark()
	Private cFilMark	:= " .AND. E1_OK == '" + cMark + "'"
	Private ASBACE    	:= ""  
	Private aAuxTit     := {} 				
	//_______________________________________________________________________________________________________________________________ 
	//                                                                                                                               | 
	// Variável que controla o fluxo da operação. Se for .T., fica subentendido que a chamada da função se procedeu do Faturamento,  | 
	// caso contrário, a mesma se procedeu do Financeiro.   	                                                                     |
	//_______________________________________________________________________________________________________________________________|	

	Default aTitulos := {}


	//_______________________________________________________________________________________________________________________________
	//                                                                                                                               | 
	// Controla a procedência da chamada da rotina                                                                                   |
	//_______________________________________________________________________________________________________________________________|

	aAuxTit := aClone(aTitulos)



	Tamanho  := "M"
	titulo   := "Impressao de Boleto com Codigo de Barras"
	cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SE1"
	wnrel    := "FINRE001"
	lEnd     := .F.
	cPerg     :="FINRE001"
	aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0  


	//_______________________________________________________________________________________
	//                                                                                       |  
	// Analisa  a origem da chamada da rotina                                                |
	//_______________________________________________________________________________________|

	If Empty(aTitulos)

		DbSelectArea("SX1")
		DbSetOrder(1)
		If !DbSeek(PadR("FINRE001",Len(SX1->X1_GRUPO))+"01")

			Aadd(aPergs,{"De Prefixo"				,"","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"Ate Prefixo"				,"","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"De Numero"				,"","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"Ate Numero"				,"","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"De Parcela"				,"","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"Ate Parcela"				,"","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"De Cliente"				,"","","mv_ch9","C",6,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
			Aadd(aPergs,{"Ate Cliente"				,"","","mv_cha","C",6,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
			Aadd(aPergs,{"De Loja"					,"","","mv_chb","C",2,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"Ate Loja"					,"","","mv_chc","C",2,0,0,"G","","MV_PAR10","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"De Emissao"				,"","","mv_chd","D",8,0,0,"G","","MV_PAR11","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"Ate Emissao"				,"","","mv_che","D",8,0,0,"G","","MV_PAR12","","","","31/12/20","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"De Vencimento"			,"","","mv_chf","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"Ate Vencimento"			,"","","mv_chg","D",8,0,0,"G","","MV_PAR14","","","","31/12/20","","","","","","","","","","","","","","","","","","","","","","","","",""})
			// Informacao a ser gravado nos campos abaixo
			Aadd(aPergs,{"Portador Gravar"					,"","","mv_chh","C",3,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
			Aadd(aPergs,{"Agencia Gravar"					,"","","mv_chi","C",5,0,0,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
			Aadd(aPergs,{"Conta Gravar"					,"","","mv_chj","C",10,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
			//Aadd(aPergs,{"Imp Lista Notas ?	"		,"","","mv_chg","N",1,0,0,"C","","MV_PAR15","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","","",""})	
			AjustaSx1(cPerg,aPergs) 

		EndIf

		Pergunte (cPerg, .T.)
	Endif

	LimpaFlag()

	dbSelectArea("SE1")    
	//Pergunte (cPerg,.F.)


	//========================================CONSULTA DADOS DOS TITULOS PARA GERAR BOLETOS=============================================
	cIndexName	:= Criatrab(Nil,.F.)
	cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"

	//________________________________________________________________________________________________
	//                                                                                                | 
	// Condição que determina a origem o fluxo de processamento da operação                           |
	//________________________________________________________________________________________________|

	If Empty(aTitulos)

		cFilter		+= " E1_FILIAL=='"+xFilial("SE1")+"'"
		cFilter		+= ".And. E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'"
		cFilter		+= ".And. E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'"
		cFilter		+= ".And. E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'"
		cFilter		+= ".And. E1_CLIENTE>='" + MV_PAR07 + "'.And.E1_CLIENTE<='" + MV_PAR08 + "'"
		cFilter		+= ".And. E1_LOJA>='" + MV_PAR09 + "'.And.E1_LOJA<='"+MV_PAR10+"'"
		cFilter		+= ".And. DTOS(E1_EMISSAO)>='"+DTOS(mv_par11)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par12)+"'"
		cFilter		+= '.And. DTOS(E1_VENCREA)>="'+DTOS(mv_par13)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par14)+'"'
		//cFilter	+= ".And. E1_PORTADO = '021' "//Banestes
		cFilter		+= " .And. !(E1_TIPO$MVABATIM)"

		DbSelectArea("SE1")
		DbSetOrder(1)

	Else 
		//____________________________________________________________________________________________________________________
		//                                                                                                                    | 
		// Tratamento específico para os Títulos selecioinados a fim de que os mesmos possam ser incluídos na consulta da SE1 |
		//____________________________________________________________________________________________________________________|


		If  Len(aTitulos) == 2

			cFilter += " E1_FILIAL =='"+xFilial("SE1")+"'  .And.  E1_NUM='" + aTitulos[1][1] + "' "   
		Else
			//_________________________________________________________________________________________________________________			 	 
			//                                                                                                                 | 
			// Tratamento específico apenas em situações em que a quantidade de Título seja maior que 1                        |
			//_________________________________________________________________________________________________________________|

			For nK := 1 To Len(aTitulos)-1

				If nK == 1 
					cFilter += " ( E1_NUM='" + aTitulos[nK][1] + "' " 	 
				Else 
					cFilter += " .Or. E1_NUM='" + aTitulos[nK][1] + "' " 	 		  	 
				Endif  
			Next nK  

			cFilter += " )"

			cFilter += " .And. E1_FILIAL =='"+xFilial("SE1")+"' "                                                                                       	

		Endif 

		dbSelectArea("SE1")	 
		SE1->(dbSetOrder(1))

	Endif 


	//DbSelectArea("SE1")
	DbSetOrder(1)
	DbSetFilter({|| &cFilter }, cFilter)


	//_____________________________________________________________________________________________________________________
	//                                                                                                                     |
	// A interface principal de seleção de Título apenas será exibida se a chamada à função for realizada pelo Financeiro  | 
	//_____________________________________________________________________________________________________________________|

	If Empty(aTitulos)

		//========================================MONTA A INTERFACE DE SELECAO DOS TITULOS=============================================
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
		oMark := MsSelect():New("SE1", "E1_OK",,, .F., @cMark,{0, 0, 175, 352})
		oMark:bMark := {|| BOLMARK()}
		//oMark:oBrowse:lCanAllMark := .T.
		@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
		ACTIVATE DIALOG oDlg CENTERED

		If lExec
			Processa({|lEnd|MontaRel()})
		Endif     

	Else 
		Processa({|lEnd|MontaRel()})
	Endif  

	SE1->(DbClearFilter())

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
l±±³Programa  ³  MontaRel³ Autor ³ TIAGO ROSSINI        ³ Data ³ 08/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RETORNA DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel()

	Local nX := 0

	Local cNroDocRea :=  ""
	Local aDadosEmp := {SM0->M0_NOMECOM,;	//[1]Nome da Empresa
	SM0->M0_ENDCOB																,;	//[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,;	//[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)				,;	//[4]CEP
	"PABX/FAX: "+SM0->M0_TEL													,;	//[5]Telefones
	"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+				;	//[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+						;	//[6]
	Subs(SM0->M0_CGC,13,2)														,;	//[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+			;	//[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }	//[7]I.E

	Local aDadosTit
	Local aDadosBanco
	Local aDatSacado
	/*LOCAL aBolText := {	"Após o vencimento cobrar multa de R$ "                ,;
	"Mora Diaria de R$ "                                   ,;
	"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}
	*/

	LOCAL aBolText     := { "APOS O VENCIMENTO COBRAR JUROS DE R$ ",;
	"APOS O VENCIMENTO COBRAR MULTA DE R$ ",;
	"SUJEITO A PROTESTO APOS 05 (CINCO) DIAS DO VENCIMENTO",;
	"NFe: "}

	Local aBolTextEXC	:= {"Após o vencimento cobrar juros de 1% am",;
	"Após Vencimento Cobrar Multa de 2% ",;
	"PROTESTAR APOS 3 DIAS DO VENCIMENTO"}

	Local aBolText1 := { "MORA DIARIA DE 0,33%",;
	"PROTESTO AUTOMATICO APOS 05 DIAS DE VENCIMENTO"}

	Local nI 		:= 1
	Local aCB_RN_NN	:= {}
	Local nVlrAbat 	:= 0
	Local cBanco 	:= ""
	Local cNomBanco := ""
	Local cAgencia 	:= ""
	Local cConta 	:= ""
	Local cContaReal:= ""
	Local cDigConta := ""
	Local cCodCar 	:= ""
	Local cEspecie 	:= ""

	Private cNroDoc :=  ""
	Private cDocumento := ""
	Private oPrint

	oPrint:= TMSPrinter():New( "Boleto Laser" )
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:StartPage()   // Inicia uma nova página

	// grava as informações Bco, Agencia e Conta antes de processar o relatorio
	DbSelectArea("SE1")
	DbSetOrder(1)       

	//________________________________________________________________________
	//                                                                        | 
	// Não considera o filtro cuja marcação é especifica no campo E1_OK       | 
	//________________________________________________________________________|
	If Empty(aAuxTit)
		cFilter += cFilMark                                                       
	Endif

	DbSetFilter({|| &cFilter }, cFilter)
	dbGoTop()

	Do While ! SE1->(EOF())  
		RecLock("SE1",.F.)
		E1_PORTADO  := iif ( !Empty(aAuxTit), aAuxTit[Len(aAuxTit)][1], MV_PAR15 ) 
		E1_AGEDEP 	:= iif ( !Empty(aAuxTit), aAuxTit[Len(aAuxTit)][2], MV_PAR16 )     
		E1_CONTA    := iif ( !Empty(aAuxTit), aAuxTit[Len(aAuxTit)][3], MV_PAR17 ) 
		dbSkip() 
		MsUnLock()

	EndDo

	//	DbSelectArea("SE1")
	//	DbSetOrder(1)
	//	cFilter += cFilMark
	//	DbSetFilter({|| &cFilter }, cFilter)
	dbGoTop()

	Do While ! SE1->(EOF())  

		//Verifica se nosso numero, caso nao esteja gerado cria numero conf. parametros
		If Empty(SE1->E1_IDCNAB) .OR. (SE1->E1_PORTADO <> mv_par01)
			cNossoNumero :=  U_TCNABNSN("021")
		EndIf

		//Posiciona o SA6 (Bancos)
		DbSelectArea("SA6")
		DbSetOrder(1)
		If DbSeek(xFilial("SA6")+SE1->("021"+E1_AGEDEP+E1_CONTA),.T.)

			If SA6->A6_COD == "001"
				cBanco := SA6->A6_COD
				cNomBanco := "BANCO DO BRASIL"
				cAgencia 	:= SA6->A6_AGENCIA
				cConta 		:= SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)
				cDigConta := SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)
				cCodCar := "17/019"
				_cTipo := "9"

			ElseIf SA6->A6_COD == "237"
				cBanco := SA6->A6_COD
				cNomBanco := "BRADESCO"
				cAgencia := SUBSTR(SA6->A6_AGENCIA,1,4)
				cConta := SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)
				cDigConta := SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)
				cCodCar := "17"
				_cTipo := "9"

			ElseIf SA6->A6_COD == "341"
				cBanco := SA6->A6_COD
				cNomBanco 	:= "BANCO ITAU SA"
				cAgencia 	:= SUBSTR(SA6->A6_AGENCIA,1,4)
				cConta 		:= AllTrim(SA6->A6_NUMCON)
				cDigConta 	:= AllTrim(SA6->A6_DVCTA)
				cCodCar := "109"
				_cTipo := "9"

			ElseIf SA6->A6_COD == "021"
				cBanco := SA6->A6_COD
				cNomBanco := "BANCO BANESTES"
				cAgencia := SA6->A6_AGENCIA
				cConta := SA6->A6_NUMCON
				cDigConta := ""
				cCodCar := 'C.ESCRI'//"11"
				_cTipo := "3"

			ElseIf SA6->A6_COD == "356"
				cBanco := "356"
				cNomBanco := "BANCO REAL"
				cAgencia := SUBSTR(SA6->A6_AGENCIA,1,4)
				cConta := SUBSTR(SA6->A6_NUMCON,1,7)
				cContaReal := AllTrim(SA6->A6_NUMCON)
				_cParam := STRZERO(Val(SE1->E1_IDCNAB), 13) + cAgencia + cConta
				cDigConta := DigConta(_cParam)
				cCodCar := "42"
				_cTipo := "5"

			ElseIf SA6->A6_COD == "033"
				cBanco := "033"
				cNomBanco := "BANCO SANTANDER"
				cAgencia := AllTrim(SA6->A6_AGENCIA)
				cConta := "00000000" // codigo cedente padrao santander
				cDigConta := "0" // usado para informar o digito da agencia
				cCodCar := "101-C/ REGISTRO"

			ElseIf SA6->A6_COD == "104"
				cBanco := "104"
				cNomBanco := "CAIXA ECONÔMICA"
				cAgencia := SUBSTR(SA6->A6_AGENCIA,1,4)
				cConta := SUBSTR(ALLTRIM(SA6->A6_NUMCON),1,7)
				cDigConta := ""
				cCodCar := "CR"
				_cTipo := "0"

			ElseIf SA6->A6_COD == "004"
				cBanco := "004"
				cNomBanco := "BANCO NORDESTE"
				cAgencia := SUBSTR(SA6->A6_AGENCIA,1,4)
				cConta := SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)
				cDigConta := SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)
				cCodCar := "50"
				_cTipo := "3"
			EndIf

			_cBanco := If(SA6->A6_COD == "356", "356", SA6->A6_COD)

			//Posiciona na Arq de Parametros CNAB
			DbSelectArea("SEE")
			DbSetOrder(1)
			DbSeek(xFilial("SEE")+SE1->(SA6->(A6_COD+A6_AGENCIA+A6_NUMCON)),.T.)

			//Posiciona o SA1 (Cliente)
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

			DbSelectArea("SE1")

			aDadosBanco  := {cBanco,;	// [1]Numero do Banco
			cNomBanco,; // [2]Nome do Banco
			cAgencia,;	// [3]Agência
			cConta,;	// [4]Conta Corrente
			cDigConta,;	// [5]Dígito da conta corrente
			cCodCar}	// [6]Codigo da Carteira

			If Empty(SA1->A1_ENDCOB)
				aDatSacado := {AllTrim(SA1->A1_NOME),;  // [1]Razão Social
				AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA,;  // [2]Código
				AllTrim(SA1->A1_END)+"-"+AllTrim(SA1->A1_BAIRRO),;  // [3]Endereço
				AllTrim(SA1->A1_MUN),;  	// [4]Cidade
				SA1->A1_EST,;     	// [5]Estado
				SA1->A1_CEP,;      // [6]CEP
				SA1->A1_CGC,;		// [7]CGC
				SA1->A1_PESSOA}		// [8]PESSOA
			Else
				aDatSacado := {AllTrim(SA1->A1_NOME),;   	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA,;   	// [2]Código
				AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;  	// [3]Endereço
				AllTrim(SA1->A1_MUNC),;   	// [4]Cidade
				SA1->A1_ESTC,;   	// [5]Estado
				SA1->A1_CEPC,;   	// [6]CEP
				SA1->A1_CGC,;		// [7]CGC
				SA1->A1_PESSOA}		// [8]PESSOA
			Endif

			DbSelectArea("SE1")
			nVlrAbat :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

			If cBanco == "001"
				cNroDoc := SE1->E1_IDCNAB //TRANSFORM(cConvBB+AllTrim(SE1->E1_IDCNAB),"@R 99999999999999999")
				cEspecie := "DM"
			ElseIf cBanco == "237"
				cNroDoc := TRANSFORM(SE1->E1_IDCNAB,"@R 99999999999-X")
				cEspecie := "DM"
			ElseIf cBanco == "237"
				cNroDoc := TRANSFORM(SE1->E1_IDCNAB,"@R 99999999-9")
				cEspecie := "DM"
			ElseIf cBanco == "021"
				cNroDoc := TRANSFORM(SE1->E1_IDCNAB,"@R 99999999-99")
				cEspecie := "DM"
			ElseIf cBanco == "356"
				cNroDoc := STRZERO(Val(SE1->E1_IDCNAB), 13)
				cEspecie := "NF"
			ElseIf cBanco == "033"
				cNroDoc := TRANSFORM(SE1->E1_IDCNAB,"@R 999999999999-9")
				cEspecie := "NF"
			ElseIf cBanco == "104"
				cNroDoc := TRANSFORM(SE1->E1_IDCNAB,"@R 9999999999-9")
				cEspecie := "NF"
			ElseIf cBanco == "004"
				cNroDoc := TRANSFORM(SE1->E1_IDCNAB,"@R 99999999-9")
				cEspecie := "DM"
			EndIf

			DbSelectArea("SE1")
			RecLock("SE1", .F.)
			//	SE1->E1_PORTADO := cBanco
			//	SE1->E1_AGEDEP := cAgencia		
			SE1->E1_CONTA 	:= SA6->A6_NUMCON
			//	SE1->E1_PORCJUR := 2
			SE1->E1_VALJUR  := SE1->E1_VALOR*(0.2/100) 
			SE1->E1_NUMBCO 	:= cNossoNumero 
			//SE1->E1_CONTA := cConta	
			SE1->(MsUnlock())

			If cBanco $ "001"
				// Cod barra para banestes e banco do brasil
				fCodBar(aDadosBanco[1] + _cTipo, aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"",(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO)
			ElseIf cBanco $ "021"
				fCodBarBane(aDadosBanco[1] + _cTipo, aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"",(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO)
			ElseIf cBanco $ "237"
				fCodBarBrd(aDadosBanco[1] + _cTipo, aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"",(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO)
			ElseIf cBanco $ "356"
				cNroDocRea := Modulo10(Alltrim(SE1->E1_IDCNAB) + cAgencia + cConta)
				fReaCodBar(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],Alltrim(SE1->E1_IDCNAB),(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO,cNroDocRea)
			ElseIf cBanco $ "033"
				fCodBarSan(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],Alltrim(SE1->E1_IDCNAB),(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO)
			ElseIf cBanco $ "104"
				fCodBarCef(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],Alltrim(SE1->E1_IDCNAB),(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO)
			ElseIf cBanco $ "004"
				fCodBarBnb(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],Alltrim(SE1->E1_IDCNAB),(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO)
			ElseIf cBanco $ "021"	// 341 ITAU 
				nVlrAbat   := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				cCodCli    := SE1->E1_Cliente             
				cDocumento := SE1->E1_NUM+Alltrim(SE1->E1_PARCELA)
				cNroDoc    := PADL(Alltrim(E1_IDCNAB), 8, "0")

				fCodBaITAU(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5], (SE1->E1_VALOR-nVlrAbat)*100, SE1->E1_VENCTO, cCodCar,cCodCli,)
				//fCodBaITAU(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cCart,cCodCli,cNroDoc)

			EndIf 

			aDadosTit	:= {SE1->E1_NUM+SE1->E1_PARCELA,;  				// [1] Número do título
			SE1->E1_EMISSAO,;  				// [2] Data da emissão do título
			dDataBase,;  					// [3] Data da emissão do boleto
			SE1->E1_VENCTO,;  				// [4] Data do vencimento
			(SE1->E1_SALDO - nVlrAbat),; 	// [5] Valor do título
			cNroDoc,;  						// [6] Nosso número (Ver fórmula para calculo)
			SE1->E1_PREFIXO,;  				// [7] Prefixo da NF
			cEspecie,;  					// [8] Tipo do Titulo
			SE1->E1_PORCJUR}   				// [9] Juros ao dia

			fPrintBol(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aBolText1,aBolTextEXC,_cLinDig,_cCodBar,cNroDocRea, SE1->E1_VALJUR,SE1->E1_PORCJUR, SE1->E1_ACRESC ,SE1->E1_DECRESC)
			nX := nX + 1

			nI := nI + 1
		EndIf  

		DbSelectArea("SE1")
		dbSkip() 

	EndDo

	oPrint:EndPage()     // Finaliza a página
	oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  fPrintBol ³ Autor ³ Microsiga           ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fPrintBol(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aBolText1,aBolTextEXC,_cLinDig,_cCodBar, cNroDocRea;
	, nVlJuros, nPorJuros, nAcres, nDeducao)

	Local nI 			:= 0
	Local cLogo 		:= Curdir() + "Logo\bBanestes.bmp"

	Private oFont8
	Private oFont11c
	Private oFont11n
	Private oFont10
	Private oFont14
	Private oFont16n
	Private oFont15
	Private oFont14n
	Private oFont24
	Private aRelaNotas	:= {}

	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont8  		:= TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11c 		:= TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11n 		:= TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12  		:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  		:= TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  		:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  		:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  		:= TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n 		:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  		:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n 		:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n 		:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  		:= TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

	oPrint:StartPage()   // Inicia uma nova página

	/******************/
	/* PRIMEIRA PARTE */
	/******************/

	cNomeBanco := aDadosBanco[2]	
	nRow1 := 100

	oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
	oPrint:Line (nRow1+0150,710,nRow1+0070, 710) 

	oPrint:Line (nRow1+0150,100,nRow1+0550,100)
	oPrint:Line (nRow1+0150,2300,nRow1+0550,2300)

	//	If File(cLogo)


	oPrint:SayBitmap(nRow1+0044, 090, cLogo, 340, 090)
	//oPrint:Say  (nRow1+0084,200,cNomeBanco,oFont8 )	// [2]Nome do Banco
	/*Else
	oPrint:Say(nRow1+0084,100,aDadosBanco[2],oFont12)	// [2]Nome do Banco 
	EndIf
	*/	
	If aDadosBanco[1] == "033" //Santander
		oPrint:Say  (nRow1+0075,513,"  " + aDadosBanco[1],oFont21 )		 // [1]Numero do Banco
	ElseIf aDadosBanco[1] == "021"
		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-3",oFont21 )		 // [1]Numero do Banco	
	Else                                                                 
		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-"+_cTipo,oFont21 )	 // [1]Numero do Banco
	endif

	oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

	oPrint:Say  (nRow1+0150,110 ,"Cedente",oFont8)
	oPrint:Say  (nRow1+0200,110 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

	oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
	If aDadosBanco[1] == "001"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	ElseIf aDadosBanco[1] == "237"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	ElseIF aDadosBanco[1] == "021"
		cString := AllTrim(aDadosBanco[3])+"/"+TRANSFORM(aDadosBanco[4],"@R 99.999.999")
	ElseIF aDadosBanco[1] == "356"
		cString := TRANSFORM(aDadosBanco[3] + aDadosBanco[4]+strzero(cNroDocRea,1),"@R 9999/9999999-9")
	ElseIF aDadosBanco[1] == "033"
		cString := TRANSFORM(aDadosBanco[3]+aDadosBanco[5]+ aDadosBanco[4],"@R 9999-9/9999999")
	ElseIF aDadosBanco[1] == "004"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	ElseIF aDadosBanco[1] == "104"
		//cString := AllTrim(aDadosBanco[3])+"/"+TRANSFORM(aDadosBanco[4],"@R 9999999")
		cString := "2042/208599-2"
	ElseIF aDadosBanco[1] == "021"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]

	EndIF

	oPrint:Say  (nRow1+0200,1060,cString,oFont10)

	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10)//Prefixo +Numero+Parcela

	oPrint:Say  (nRow1+0250,110 ,"Sacado",oFont8)
	oPrint:Say  (nRow1+0300,110 ,aDatSacado[1],oFont10)			//Nome

	oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oPrint:Say  (nRow1+0250,1510,"(=)Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (nRow1+0400,0110,"Recebi(emos) o bloqueto/título",oFont10)
	oPrint:Say  (nRow1+0450,0110,"com as características acima.",oFont10)
	oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
	oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

	oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
	oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
	oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

	oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
	oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
	oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
	oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

	oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"					,oFont8)
	oPrint:Say  (nRow1+0205,1910,"(  )Ausente"					,oFont8)
	oPrint:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"	,oFont8)
	oPrint:Say  (nRow1+0285,1910,"(  )Recusado"					,oFont8)
	oPrint:Say  (nRow1+0325,1910,"(  )Não procurado"			,oFont8)
	oPrint:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"	,oFont8)
	oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"				,oFont8)
	oPrint:Say  (nRow1+0445,1910,"(  )Falecido"					,oFont8)
	oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"	,oFont8)


	/*****************/
	/* SEGUNDA PARTE */
	/*****************/

	nRow2 := 150

	oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
	oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
	oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

	oPrint:Say  (nRow2+0600,2000,"Recibo do Sacado",oFont10) //oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

	/*If File(cLogo)
	oPrint:SayBitmap(nRow2+0620,100,cLogo,400,090)

	Else
	oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont12 )		// [2]Nome do Banco 
	EndIf
	*/

	oPrint:SayBitmap(nRow2+0604, 090, cLogo, 340, 090)	
	//oPrint:Say  (nRow2+0644,200,cNomeBanco,oFont8 )		// [2]Nome do Banco

	If aDadosBanco[1] == "033" //Santander
		oPrint:Say  (nRow2+0635,513,"  " +aDadosBanco[1],oFont21 )	// [1]Numero do Banco
	ElseIf aDadosBanco[1] == "021"
		oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-3",oFont21 )	// [1]Numero do Banco
	Else
		oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-"+_cTipo,oFont21 )	// [1]Numero do Banco
	Endif

	//oPrint:Say  (nRow2+0644,2000,"Recibo do Sacado",oFont10)


	//	If aDadosBanco[1] == "001" //Banco do Brasil - Fábio Lemos 27/11 - Solicitação do Banco

	oPrint:Say  (nRow2+645,755,_cLinDig,oFont15n)
	//	EndIf

	oPrint:Line (nRow2+0810,100,nRow2+0810,2300)
	oPrint:Line (nRow2+0910,100,nRow2+0910,2300)
	oPrint:Line (nRow2+0980,100,nRow2+0980,2300)
	oPrint:Line (nRow2+1050,100,nRow2+1050,2300) 

	oPrint:Line (nRow2+0710,100,nRow2+1640,100)
	oPrint:Line (nRow2+0710,2300,nRow2+1640,2300)

	oPrint:Line (nRow2+0910,500,nRow2+1050,500)
	oPrint:Line (nRow2+0980,750,nRow2+1050,750)
	oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
	oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
	oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

	oPrint:Say  (nRow2+0710,110 ,"Local de Pagamento"        ,oFont8)
	If aDadosBanco[1] == "021" //Banestes
		oPrint:Say  (nRow2+0725,400 ,"PREFERENCIALMENTE NA REDE BANESTES",oFont10)
	ElseIf aDadosBanco[1] == "021" //Itau	
		oPrint:Say  (nRow2+0725,400 ,"ATÉ O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAÚ      ",oFont10)
		oPrint:Say  (nRow2+0765,400 ,"APÓS O VENCIMENTO PAGUE SOMENTE NO ITAÚ      ",oFont10) 
	Else
		oPrint:Say  (nRow2+0725,400 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO",oFont10)
	EndIF

	oPrint:Say  (nRow2+0710,1810,"Vencimento"                ,oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0810,110 ,"Cedente"                   ,oFont8)
	oPrint:Say  (nRow2+0850,110 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

	oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente"    ,oFont8)
	If aDadosBanco[1] == "001"
		cString := Alltrim(Substr(aDadosBanco[3],1,4)+"-"+Substr(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	ElseIf aDadosBanco[1] == "237"
		cString := Alltrim(Substr(aDadosBanco[3],1,4)+"-"+Substr(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])

	ElseIF aDadosBanco[1] == "021"
		cString := AllTrim(aDadosBanco[3])+"/"+TRANSFORM(aDadosBanco[4],"@R 99.999.999")
	ElseIF aDadosBanco[1] == "356"
		cString := TRANSFORM(aDadosBanco[3] + aDadosBanco[4]+strzero(cNroDocRea,1),"@R 9999/9999999-9")
	ElseIF aDadosBanco[1] == "033"
		cString := TRANSFORM(aDadosBanco[3]+aDadosBanco[5]+ aDadosBanco[4],"@R 9999-9/9999999")
	ElseIF aDadosBanco[1] == "004"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	ElseIF aDadosBanco[1] == "104"
		//cString := AllTrim(aDadosBanco[3])+"/"+TRANSFORM(aDadosBanco[4],"@R 9999999")
		cString := "0000/000000-0"
	ElseIF aDadosBanco[1] == "021"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	EndIF

	nCol := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0910,110 ,"Data do Documento"         ,oFont8)
	oPrint:Say  (nRow2+0940,110, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

	oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"             ,oFont8)
	oPrint:Say  (nRow2+0940,605 ,IIF(!Empty(aDadosTit[7]),aDadosTit[7]+"-","")+Alltrim(Substr(aDadosTit[1],1,9))+IIF(!Empty(Substr(aDadosTit[1],10,1)),"-"+Substr(aDadosTit[1],10,1),"")  ,oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow2+0910,1005,"Espécie Doc."              ,oFont8)
	oPrint:Say  (nRow2+0940,1050,aDadosTit[8]				  ,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow2+0910,1305,"Aceite"                    ,oFont8)
	oPrint:Say  (nRow2+0940,1400,"N"                         ,oFont10)

	oPrint:Say  (nRow2+0910,1485,"Data do Processamento"     ,oFont8)
	oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +;
	"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

	oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
	/*
	If aDadosBanco[1] == "021" //Itau
	cString := aDadosBanco[6]+"/"+aDadosTit[6]
	Else                       
	*/	
	cString := aDadosTit[6]
	//	EndIf

	nCol := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0980,110 ,"Uso do Banco", oFont8)
	//If aDadosBanco[1] == "021"
	//	oPrint:Say  (nRow2+1010,150 ,"3", oFont8)
	//EndIF

	oPrint:Say  (nRow2+0980,505 ,"Carteira", oFont8)
	If aDadosBanco[1] == "033"
		oPrint:Say  (nRow2+1010,505 ,aDadosBanco[6], oFont8)
	else
		oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6], oFont10)
	endif

	oPrint:Say  (nRow2+0980,755 ,"Espécie", oFont8)
	oPrint:Say  (nRow2+1010,805 ,"R$", oFont10)

	oPrint:Say  (nRow2+0980,1005,"Quantidade", oFont8)
	oPrint:Say  (nRow2+0980,1485,"Valor", oFont8)

	oPrint:Say  (nRow2+0980,1810,"(=)Valor do Documento", oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)
	/*
	IF aDatSacado[2] = "T55762"
	oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow2+1150,100 ,aBolTextEXC[1], oFont10)
	oPrint:Say  (nRow2+1200,100 ,aBolTextEXC[2], oFont10)
	ELSE
	oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow2+1150,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*nFatJurDia),"@E 99,999.99")), oFont10)
	oPrint:Say  (nRow2+1200,100 ,aBolText[3], oFont10)
	END                                                 
	*/

	oPrint:Say  (nRow2+1050,110 ,"INSTRUÇÕES (DE RESPONSABILIDADE DO CEDENTE)",oFont8)
	nPosObs := 1150 
	//If nPorJuros > 0
	oPrint:Say  (nRow2+nPosObs,110 ,aBolText1[1],oFont10)
	nPosObs += 50
	//EndIf     

	//If nVlJuros > 0
	oPrint:Say  (nRow2+nPosObs,110 ,aBolText1[2],oFont10)
	nPosObs += 50
	//EndIf                                                  

	//	oPrint:Say  (nRow2+nPosObs+050,110 ,'Título sujeito a protesto após 7 dias corridos depois de vencido.',oFont10)
	oPrint:Say  (nRow2+nPosObs+100,110 ,'CHAVE ASBACE:' + Transform(M->ASBACE, '@R 9999.9999.9999.9999.9999.9999') + '  R.V.A.', oFont10)

	oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

	oPrint:Say  (nRow2+1400,110 ,"Sacado"                                         ,oFont8)
	cCNPJ_CPF := ""
	If aDatSacado[8] = "J"
		cCNPJ_CPF := SPACE(10)+"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99") // CGC
	Else
		cCNPJ_CPF :=SPACE(10)+"CPF.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99") 	// CPF
	EndIf
	//	If aDatSacado[8] = "J"
	//		oPrint:Say  (nRow2+1440,1810 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	//	Else
	//		oPrint:Say  (nRow2+1440,1810 ,"CPF.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	//	EndIf

	oPrint:Say  (nRow2+1440,110 ,aDatSacado[1]+" ("+aDatSacado[2]+")"+cCNPJ_CPF             ,oFont10) // RAZAO+CODIGO+CNPJ
	oPrint:Say  (nRow2+1470,110 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (nRow2+1500,110 ,"CEP.: "+aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

	oPrint:Say  (nRow2+1500,700,aDadosTit[6],oFont10)

	oPrint:Say  (nRow2+1605,0110 ,"Sacador/Avalista",oFont8)
	oPrint:Say  (nRow2+1645,1500,"Autenticação Mecânica",oFont8)    

	oPrint:Say  (nRow2+1605,1810,"Código de baixa",oFont8)

	//	oPrint:Line (nRow2+0710,1800,nRow2+1640,1800 )
	oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
	oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
	oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
	oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
	oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
	oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
	oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )                

	oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )

	MSBAR3("INT25",15.85,1,_cCodBar,oPrint,.F.,Nil,.T.,0.028,1.02,Nil,Nil,Nil,.F.) //Impressora Laser


	/******************/
	/* TERCEIRA PARTE */
	/******************/

	//	nRow3 := 206
	nRow3 := 350

	//Imprime linha de corte da ficha de compensacao
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI

	//Imprime linha de corte do rodape
	//	For nI := 100 to 2300 step 50
	//		oPrint:Line(nRow3+3120, nI, nRow3+3120, nI+30)
	//	Next nI

	oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
	oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

	/*If File(cLogo)
	oPrint:SayBitmap(nRow3+1910,100,cLogo,400,090)
	Else
	oPrint:Say(nRow3+1934,100,aDadosBanco[2],oFont12 )		// 	[2]Nome do Banco 
	EndIf
	*/ 

	oPrint:sayBitmap(nRow3+1900, 090, cLogo, 340, 090)	
	//oPrint:Say(nRow3+1934,200,cNomeBanco,oFont10 )		// 	[2]Nome do Banco

	If aDadosBanco[1] == "033" //Santander
		oPrint:Say  (nRow3+1925,513,"  " +aDadosBanco[1],oFont21 )	// 	[1]Numero do Banco
	ElseIf aDadosBanco[1] == "021"
		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-3",oFont21 )	// 	[1]Numero do Banco	
	Else
		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-"+_cTipo,oFont21 )	// 	[1]Numero do Banco
	Endif                                                                                     

	oPrint:Say  (nRow3+1934,755,_cLinDig,oFont15n)			//	Linha Digitavel do Codigo de Barras

	oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,100,nRow3+2340,2300 ) 

	oPrint:Line (nRow3+2000,100,nRow3+2850,100)
	oPrint:Line (nRow3+2000,2300,nRow3+2850,2300)

	oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
	oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
	oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
	oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
	oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

	oPrint:Say  (nRow3+2000,110 ,"Local de Pagamento",oFont8)
	If aDadosBanco[1] == "021" //Banestes
		oPrint:Say  (nRow3+2015,400 ,"PREFERENCIALMENTE NA REDE BANESTES",oFont10)
	ElseIf aDadosBanco[1] == "021" //Itau
		oPrint:Say  (nRow3+2015,400 ,"ATÉ O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAÚ      ",oFont10)
		oPrint:Say  (nRow3+2055,400 ,"APÓS O VENCIMENTO PAGUE SOMENTE NO ITAÚ      ",oFont10)    	
	Else
		oPrint:Say  (nRow3+2015,400 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO",oFont10)
	EndIf

	oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2100,110 ,"Cedente",oFont8)
	oPrint:Say  (nRow3+2140,110 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

	oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
	If aDadosBanco[1] == "001"
		cString := Alltrim(Substr(aDadosBanco[3],1,4)+"-"+Substr(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	ElseIf aDadosBanco[1] == "237"
		cString := Alltrim(Substr(aDadosBanco[3],1,4)+"-"+Substr(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	ElseIF aDadosBanco[1] == "021"
		cString := AllTrim(aDadosBanco[3])+"/"+TRANSFORM(aDadosBanco[4],"@R 99.999.999")
	ElseIF aDadosBanco[1] == "356"
		cString := TRANSFORM(aDadosBanco[3] + aDadosBanco[4]+strzero(cNroDocRea,1),"@R 9999/9999999-9")
	ElseIF aDadosBanco[1] == "033"
		cString := TRANSFORM(aDadosBanco[3]+aDadosBanco[5]+ aDadosBanco[4],"@R 9999-9/9999999")
	ElseIF aDadosBanco[1] == "004"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
	ElseIF aDadosBanco[1] == "104"
		//	cString := AllTrim(aDadosBanco[3])+"/"+TRANSFORM(aDadosBanco[4],"@R 9999999")
		cString := "0000/000000-0"

	ElseIF aDadosBanco[1] == "021"
		cString := aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]

	EndIF
	nCol 	 := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)


	oPrint:Say  (nRow3+2200,110 ,"Data do Documento"                              ,oFont8)
	oPrint:Say (nRow3+2230,110, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


	oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (nRow3+2230,605 ,IIF(!Empty(aDadosTit[7]),aDadosTit[7]+"-","")+Alltrim(Substr(aDadosTit[1],1,9))+IIF(!Empty(Substr(aDadosTit[1],10,1)),"-"+Substr(aDadosTit[1],10,1),"")  ,oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (nRow3+2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                             ,oFont10)

	oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

	oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                   ,oFont8)
	/*
	If aDadosBanco[1] == "021" //Itau
	cString := aDadosBanco[6]+"/"+aDadosTit[6]
	Else                       
	*/	
	cString := aDadosTit[6]
	//EndIf


	nCol 	 := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2270,110 ,"Uso do Banco"                                   ,oFont8)
	//If aDadosBanco[1] == "021"
	//	oPrint:Say  (nRow3+2300,150 ,"3", oFont8)
	//EndIF
	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	If aDadosBanco[1] == "033"
		oPrint:Say  (nRow3+2300,505 ,aDadosBanco[6]                                  	,oFont8)
	else
		oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                  	,oFont10)
	endif

	oPrint:Say  (nRow3+2270,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

	oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

	oPrint:Say  (nRow3+2270,1810,"(=)Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1880+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)
	/*
	oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow3+2440,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*nFatJurDia),"@E 99,999.99")), oFont10)
	oPrint:Say  (nRow3+2490,100 ,aBolText[3], oFont10)
	*/

	nPosObs := 2440                     
	oPrint:Say  (nRow3+2340,110 ,"INSTRUÇÕES (DE RESPONSABILIDADE DO CEDENTE)",oFont8)
	//If nPorJuros > 0
	oPrint:Say  (nRow3+2440,110 ,aBolText1[1]   	,oFont10)
	nPosObs += 50
	//EndIf  

	//If nVlJuros > 0
	oPrint:Say  (nRow3+nPosObs,110 ,aBolText1[2]  	,oFont10)
	nPosObs += 50
	//EndIf


	//oPrint:Say  (nRow3+nPosObs,100 ,aBolText[3]                                      ,oFont10)	
	//nPosObs += 50                             

	//	oPrint:Say  (nRow3+nPosObs+050,110 ,'Título sujeito a protesto após 7 dias corridos depois de vencido.',oFont10)
	oPrint:Say  (nRow3+nPosObs+100,110 ,'CHAVE ASBACE:' + Transform(M->ASBACE, '@R 9999.9999.9999.9999.9999.9999') + '  R.V.A.',oFont10)

	oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

	oPrint:Say  (nRow3+2690,110 ,"Sacado"                                         ,oFont8)
	//	oPrint:Say  (nRow3+2720,110 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	oPrint:Say  (nRow3+2720,110 ,aDatSacado[1]+" ("+aDatSacado[2]+")"+cCNPJ_CPF             ,oFont10) // RAZAO+CODIGO+CNPJ

	//	if aDatSacado[8] = "J"
	//		oPrint:Say  (nRow3+2720,1810,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	//	Else
	//		oPrint:Say  (nRow3+2720,1810,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	//	EndIf

	oPrint:Say  (nRow3+2750,110 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (nRow3+2780,110 ,"CEP.: "+aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	oPrint:Say  (nRow3+2780,700,aDadosTit[6], oFont10)

	oPrint:Say  (nRow3+2815,110 ,"Sacador/Avalista"                               ,oFont8)
	oPrint:Say  (nRow3+2855,1500,"Autenticação Mecânica/Ficha de Compensação"                        ,oFont8)

	oPrint:Say  (nRow3+2815,1810,"Código de baixa",oFont8)             

	//	oPrint:Line (nRow3+2000,1800,nRow3+2850,1800 )
	oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
	oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
	oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
	oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
	oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
	oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

	oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )

	//MSBAR("INT25",25.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	//MSBAR("INT25",26.0,1,_cCodBar,oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	//MSBAR3("INT25",26.0,1,_cCodBar,oPrint,.F.,Nil,Nil,0.025,1.02,Nil,Nil,"A",.F.) //ZZ\

	// A CONFIGURACAO ABAIXO NAO DEVE SER ALTERADO, POIS SOMENTE DESTA FORMA A IMPRESSAO DO CODIGO
	// DE BARRAS SAI NA POSICAO CORRETA NA IMPRESSORA HP LASERJET P1005 (FATURAMENTO)\
	// ANDRE 03/07/08
	//MSBAR3("INT25",12.90,1,_cCodBar,oPrint,.F.,Nil,Nil,0.025,1.02,Nil,Nil,"A",.F.) //ZZ

	// COM A CONFIGURACAO ABAIXO, A IMPRESSAO DO CODIGO DE BARRAS SAI CORRETO NAS DEMAIS IMPRESSORAS
	// POREM NAO IMPRIME NA HP LASERJET P1005 (FATURAMENTO
	// ANDRE 03/07/08
	//	MSBAR3("INT25",26.10,1,_cCodBar,oPrint,.F.,Nil,Nil,0.025,1.08,Nil,Nil,"D",.F.)

	//	MSCBSAYBAR(1,26.35,"N",_cCodBar,"MB01","C",8.36,.F.,.T.,.F.,,2,1)

	//	oPrinter:FWMSBAR("INT25" /*cTypeBar*/,26.35/*nRow*/ ,1/*nCol*/, _cCodBar/*cCode*/,oPrinter/*oPrint*/,.F./*lCheck*/,/*Color*/,.T./*lHorz*/,0.025/*nWidth*/,1.08/*nHeigth*/,.T./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,2/*nPFWidth*/,2/*nPFHeigth*/,.F./*lCmtr2Pix*/)

	MSBAR3("INT25",26.35+1.35,1,_cCodBar,oPrint,.F.,Nil,.T.,0.028,1.03,Nil,Nil,Nil,.F.) //Impressora Laser
	//	nLargBar := 0.02999
	//	MSBAR3("INT25",26.35+1.35,1,_cCodBar,oPrint,.F.,Nil,.T.,nLargBar,1.03,Nil,Nil,Nil,.F.) //Impressora Laser
	oPrint:EndPage() // Finaliza a página 

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
	Local L,D,P := 0
	Local B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
	LOCAL L, D, P := 0          

	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End

	D := 11 - (mod(D,11))
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return(D)


Static Function fCodBar(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
	Private numboleta,fatorvcto,b_campo,codbarras,dv_barra,linedig,nDigito,dv_nnum,cbarra,pedaco,esc
	Private nPos	 := 0

	M->DV_NNUM   := SPACE(1)
	M->DV_BARRA  := SPACE(1)
	M->cBARRA    := ""
	M->LineDig   := ""
	M->NumBoleta := ""
	M->nDigito   := ""
	M->Pedaco    := ""
	esc := CHR(27)
	* Preparacao Inicio
	height    := 2.5
	small_bar := 3.8                               && number of points per bar  3

	wide_bar := ROUND(small_bar * 2.25,0)          && 2.25 x small_bar

	//height    := 2.5  && 2
	//small_bar := 4.2                               && number of points per bar  3
	//wide_bar := ROUND(small_bar * 2.25,0)          && 2.25 x small_bar
	dpl := 60   //50                                 && dots per line 300dpi/6lpi = 50dpl
	nb := esc+"*c"+TRANSFORM(small_bar,'99')+"a"+Alltrim(STR(height*dpl))+"b0P"+esc+"*p+"+TRANSFORM(small_bar,'99')+"X"
	// Barra estreita
	wb := esc+"*c"+TRANSFORM(wide_bar,'99')+"a"+Alltrim(STR(height*dpl))+"b0P"+esc+"*p+"+TRANSFORM(wide_bar,'99')+"X"
	// Barra larga
	ns := esc+"*p+"+TRANSFORM(small_bar,'99')+"X"
	// Espaco estreito
	ws := esc+"*p+"+TRANSFORM(wide_bar,'99')+"X"
	// Espaco largo
	_TpBar := "25"
	If _TpBar == "25"
		// Representacao binaria dos numeros 1-Barras/Espacos largas (os)
		// 0-Barras/Espacos estreitas (os)
		char25 := {}
		AADD(char25,"10001")       && "1"
		AADD(char25,"01001")       && "2"
		AADD(char25,"11000")       && "3"
		AADD(char25,"00101")       && "4"
		AADD(char25,"10100")       && "5"
		AADD(char25,"01100")       && "6"
		AADD(char25,"00011")       && "7"
		AADD(char25,"10010")       && "8"
		AADD(char25,"01010")       && "9"
		AADD(char25,"00110")       && "0"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Layout para o Banco Brasil  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cFixo1   := "4329876543298765432987654329876543298765432"
	_cFixo2   := "21212121212121212121212121212"
	_cFixo3   := "3298765432"
	** Montagem do Codigo de Barras
	_ValBol  := QtdComp(SE1->E1_VALOR)
	_fatvenc := Alltrim(Str(SE1->E1_VENCTO-CTOD("07/10/1997")))
	_Desc1 := 0.00
	_Desc2 := 0.00
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Formar a linha digitavel e o código de barras³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	M->NumBoleta := AllTrim(SE1->E1_IDCNAB)  //cConvBB + AllTrim(SE1->E1_IDCNAB)
	M->FatorVcto := Str( ( SE1->E1_VENCTO - Ctod("07/10/1997") ),4 )

	M->B_Campo := _cBanco + _cMoeda + M->FatorVcto

	M->B_Campo := M->B_Campo + StrZero((SE1->E1_VALOR*100),10)

	M->B_Campo := M->B_Campo + Replicate("0",6) + M->Numboleta + "17"

	//Calculo do Digito do Codigo de Barras
	BarraDV()
	//Compor a barra com o Digito verificador
	M->CodBarras := _cBanco + _cMoeda + M->DV_BARRA + M->FatorVcto

	M->CodBarras := M->CodBarras + StrZero((SE1->E1_VALOR*100),10)

	M->CodBarras := M->CodBarras + Replicate("0",6) + M->Numboleta + "17"

	//Montar a Linha Digitavel da Boleta
	MontaLinha()
	_cCodBar := M->CodBarras
	_cLinDig := M->LineDig

	// Monta String do codigo de barras propriamente dito
	_code := ""
	If _TpBar == "25"
		// Intercala a referencia binaria dos numeros aos pares, pois nesse tipo
		// os numeros das posicoes impares serao escritos em barras largas e barras
		// estreitas e os numeros das posicoes pares serao escritos com espacos largos
		// e espacos estreitos.
		_cBar := _cCodBar
		For _nX := 1 to 43 Step 2 && 44 porque o meu cod.possue 44 numeros
			_nNro := VAl(Substr(_cBar,_nx,1))
			If _nNro == 0
				_nNro := 10
			EndIf
			_cBarx := char25[_nNro]
			_nNro := VAl(Substr(_cBar,_nx+1,1))
			If _nNro == 0
				_nNro := 10
			EndIf
			_cBarx := _cBarx + char25[_nNro]

			For _nY := 1 to 5
				If Substr(_cBarx,_nY,1) == "0"
					// Uso Barra estreita
					_code := _code + nb
				Else
					// Uso Barra larga
					_code := _code + wb
				EndIf
				If Substr(_cBarx,_nY+5,1) == "0"
					// Uso Espaco estreito
					_code := _code + ns
				Else
					// Uso Espaco Largo
					_code := _code + ws
				EndIf
			Next
		Next
		_code := nb+ns+nb+ns+_code+wb+ns+nb
		// Guarda de inicio == Barra Estr+Esp.Estr+Barra Estr+Esp.Estr
		// Guarda de Fim    == Barra Larga +Esp.Estr+Barra Estr
		// Estes devem ser colocados antes e depois do codigo montado
	EndIf
Return

Static Function MontaLinha()
	M->LineDig := ""
	M->nDigito := ""
	M->Pedaco  := ""
	M->LineDig := ""
	M->nDigito := ""
	M->Pedaco  := ""
	//Primeiro Campo
	//Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
	M->Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,5)
	DV_LINHA()
	M->LineDig := Substr(M->CodBarras,01,03)+Substr(M->CodBarras,04,01)+Substr(M->CodBarras,20,1)+"."+;
	Substr(M->CodBarras,21,04) + M->nDigito + Space(2)
	//???? Duas Vezes???   M->LineDig := Substr(M->CodBarras,01,03)+Substr(M->CodBarras,04,01)+Substr(M->CodBarras,20,01)+"."+ Substr(M->CodBarras,21,4) + M->nDigito + Space(2)
	//Segundo Campo
	M->Pedaco  := Substr(M->CodBarras,25,10)
	DV_LINHA()
	M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
	M->nDigito+Space(2)
	//??? Duas Vezes???    M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+ M->nDigito+Space(2)
	//Terceiro Campo
	M->Pedaco  := Substr(M->CodBarras,35,10)
	DV_LINHA()
	M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
	M->nDigito+Space(2)
	//Quarto Campo
	M->LineDig := M->LineDig + DV_BARRA + Space(2)
	//Quinto Campo
	//M->LineDig  := M->LineDig + M->FatorVcto + StrZero(Int(SE1->E1_Valor*100),10)
	M->LineDig  := M->LineDig + M->FatorVcto + StrZero((SE1->E1_Valor*100),10)

Return

Static Function BarraDV()
	M->nCont := 0
	M->cPeso := 2
	For i := 43 To 1 Step -1
		M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
		M->cPeso := M->cPeso + 1
		If M->cPeso >  9
			M->cPeso := 2
		Endif
	Next
	M->Resto  := ( M->nCont % 11 )
	M->Result := ( 11 - M->Resto )
	Do Case
		Case M->Result == 10 .or. M->Result == 11
		M->DV_BARRA := "1"
		OtherWise
		M->DV_BARRA := Str(M->Result,1)
	EndCase
Return

Static Function DV_LINHA()
	nCont  := 0
	Peso   := 2

	For i := Len(M->Pedaco) to 1 Step -1

		If M->Peso == 3
			M->Peso := 1
		Endif

		If Val(SUBSTR(M->Pedaco,i,1))*M->Peso >= 10
			nVal  := Val(SUBSTR(M->Pedaco,i,1)) * M->Peso
			nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
		Else
			nCont:=nCont+(Val(SUBSTR(M->Pedaco,i,1))* M->Peso)
		Endif

		M->Peso := M->Peso + 1
	Next

	M->Dezena  := Substr(Str(nCont,2),1,1)
	M->Resto   := ( (Val(Dezena)+1) * 10) - nCont
	If M->Resto   == 10
		M->nDigito := "0"
	Else
		M->nDigito := Str(M->Resto,1)
	Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fReaCodBar   ³ Autor ³ Microsiga          ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO REAL COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fReaCodBar(cBanco,cAgencia,cConta,cDacCC,nNrBancario,nValor,dVencto,nDVNrBanc)

	Local cValorFinal := strzero(int(nValor*100),10)
	Local nDvnn			:= 0
	Local nDvcb			:= 0
	Local nDv			:= 0
	Local cNN			:= ''
	Local cRN			:= ''
	Local cCB			:= ''
	Local cS			:= ''
	Local cFator      	:= strzero(dVencto - ctod("07/10/97"),4)
	Local cCmpltoNsNr	:= '000000'

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	//cS:= cBanco + cFator +  cValorFinal + cAgencia + cConta + cDacCC + Alltrim(str(nDVNrBanc)) + cCmpltoNsNr + nNrBancario
	cS:= cBanco + "9" + cFator + cValorFinal + cAgencia + cConta + Alltrim(str(nDVNrBanc)) + cCmpltoNsNr + nNrBancario
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + Alltrim(str(nDvcb)) + SubStr(cS,5,39)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	CCC = Codigo da Carteira de Cobranca
	//	 DD = Dois primeiros digitos no nosso numero
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	cS1   := cBanco + "9" + cAgencia + SubStr(cConta,1,1)
	nDv1  := modulo10(cS1)
	cLD1  := SubStr(cS1, 1, 5) + '.' + SubStr(cS1, 6, 4) + AllTrim(Str(nDv1)) + '  '

	// 	CAMPO 2:
	//	DDDDDD = Restante do Nosso Numero
	//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	//	   FFF = Tres primeiros numeros que identificam a agencia
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	//cS2	:= SubStr(cConta,2,6) + cDacCC + Alltrim(Str(nDVNrBanc))+ SubStr(cCmpltoNsNr,1,3)
	cS2	:= SubStr(cConta,2,6) + Alltrim(Str(nDVNrBanc))+ SubStr(cCmpltoNsNr,1,3)
	nDv2:= modulo10(cS2)
	cLD2:= SubStr(cS2, 1, 5) + '.' + SubStr(cS2, 6, 5) + AllTrim(Str(nDv2)) + '  '

	// 	CAMPO 3:
	//	     F = Restante do numero que identifica a agencia
	//	GGGGGG = Numero da Conta + DAC da mesma
	//	   HHH = Zeros (Nao utilizado)
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	cS3   := SubStr(cCmpltoNsNr,3,3) + SubStr(nNrBancario,1,7)
	nDv3  := modulo10(cS3)
	cLD3  := SubStr(cS3, 1, 5) + '.' + SubStr(cS3, 6, 5) + AllTrim(Str(nDv3)) + '   '

	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cLD4  := AllTrim(Str(nDvcb)) + '   '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	cLD5  := cFator + cValorFinal

	cLD	  := cLD1 + cLD2 + cLD3 + cLD4 + cLD5

	_cLinDig := cLD
	_cCodBar := cCB

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fReaCodBar   ³ Autor ³ Microsiga          ³ Data ³ 28/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER C/ CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCodBarSan(cBanco,cAgencia,cConta,cDacCC,nNrBancario,nValor,dVencto)

	Local cValorFinal := strzero(int(nValor*100),10)
	Local nDvnn				:= 0
	Local nDvcb				:= 0
	Local nDv					:= 0
	Local cNN					:= ''
	Local cRN					:= ''
	Local cCB					:= ''
	Local cS					:= ''
	Local cFator      := strzero(dVencto - ctod("07/10/97"),4)

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	cS:= cBanco + "9" + cFator + cValorFinal + "9" + cConta + nNrBancario + "0" + "101"
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + Alltrim(str(nDvcb)) + SubStr(cS,5,44)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			  Campo 2			  Campo 3			  Campo 4		Campo 5
	//	AAABC.DDDDX		EEEFF.FFFFFY 	FGGGG.GGHHHZ	K			    UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	  C = FIXO "9"
	//	DDDD = Codigo cedente padrao santander
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	cS1   := cBanco + "99" + substr(cConta,1,4)
	nDv1  := modulo10(cS1)
	cLD1  := substr(cS1,1,5) + "." + substr(cS1,6,5) + Alltrim(str(nDv1)) + '  '

	// 	CAMPO 2:
	//	EEE = Restante codigo do cedente
	//	FFFFFFF = 7 Primeiros campos do Nosso Numero
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	cS2	:= SubStr(cConta,5,3) + LEFT(nNrBancario,7)
	nDv2:= modulo10(cS2)
	cLD2:= substr(cS2,1,5) + "." + substr(cS2,6,6) + Alltrim(str(nDv2))+ '  '

	// 	CAMPO 3:
	//	GGGGGG = Restante do nosso numero
	//	H = IOS - somente para seguradora demais, fixo 0
	//	   III = Tipo modalidade carteira : 101 - cobranca simples com registro - 102 cobranca simp. sem reg - 201 - penhor
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	cS3   := substr(nNrBancario,8, len(nNrBancario))  + "0" +  "101"
	nDv3  := modulo10(cS3)
	cLD3  := substr(cS3,1,5) + "." + substr(cS3,6,5) + Alltrim(str(nDv3)) + '   '

	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cLD4  := AllTrim(Str(nDvcb))+ '   '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	cLD5  := cFator + cValorFinal

	cLD	  := cLD1 + cLD2 + cLD3 + cLD4 + cLD5

	_cLinDig := cLD
	_cCodBar := cCB

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fReaCodBar   ³ Autor ³ Microsiga          ³ Data ³ 28/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO BRADESCO C/ CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*/
Static Function fCodBarBrd(cBanco,cAgencia,cConta,cDacCC,nNrBancario,nValor,dVencto)

Local cValorFinal := strzero(int(nValor*100),10)
Local nDvnn				:= 0
Local nDvcb				:= 0
Local nDv					:= 0
Local cNN					:= ''
Local cRN					:= ''
Local cCB					:= ''
Local cS					:= ''
Local cFator      := strzero(dVencto - ctod("07/10/97"),4)


//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
cS:= cBanco + "9" + cFator + cValorFinal + "9" + cConta + nNrBancario + "0" + "101"
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + Alltrim(str(nDvcb)) + SubStr(cS,5,44)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			  Campo 2			  Campo 3			  Campo 4		Campo 5
//	AAABC.DDDDX		EEEFF.FFFFFY 	FGGGG.GGHHHZ	K			    UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	  C = FIXO "9"
//	DDDD = Codigo cedente padrao santander
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS1   := cBanco + "99" + substr(cConta,1,4)
nDv1  := modulo10(cS1)
cLD1  := substr(cS1,1,5) + "." + substr(cS1,6,5) + Alltrim(str(nDv1)) + '  '

// 	CAMPO 2:
//	EEE = Restante codigo do cedente
//	FFFFFFF = 7 Primeiros campos do Nosso Numero
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS2	:= SubStr(cConta,5,3) + LEFT(nNrBancario,7)
nDv2:= modulo10(cS2)
cLD2:= substr(cS2,1,5) + "." + substr(cS2,6,6) + Alltrim(str(nDv2))+ '  '

// 	CAMPO 3:
//	GGGGGG = Restante do nosso numero
//	H = IOS - somente para seguradora demais, fixo 0
//	   III = Tipo modalidade carteira : 101 - cobranca simples com registro - 102 cobranca simp. sem reg - 201 - penhor
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS3   := substr(nNrBancario,8, len(nNrBancario))  + "0" +  "101"
nDv3  := modulo10(cS3)
cLD3  := substr(cS3,1,5) + "." + substr(cS3,6,5) + Alltrim(str(nDv3)) + '   '

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cLD4  := AllTrim(Str(nDvcb))+ '   '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cLD5  := cFator + cValorFinal

cLD	  := cLD1 + cLD2 + cLD3 + cLD4 + cLD5

_cLinDig := cLD
_cCodBar := cCB

Return()
/*/

Static Function fCodBarBrd(cBanco,cAgencia,cConta,cDacCC,nNrBancario,nValor,dVencto)

	Local cValorFinal := StrZero((SE1->E1_VALOR*100),10)
	Local nDvnn				:= 0
	Local nDvcb				:= 0
	Local nDv					:= 0
	Local cNN					:= ''
	Local cRN					:= ''
	Local cCB					:= ''
	Local cS					:= ''
	Local nNossoNumero          := SUBSTR(SE1->E1_IDCNAB,1,11)
	Local cFator      := strzero(dVencto - ctod("07/10/97"),4)


	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------


	cS:= substr(cBanco,1,3) + "9" + substr(cFator,1,4) + cValorFinal + STRZERO(val(cAgencia),4) + "17" + nNossoNumero + STRZERO(val(cConta),7) + "0"

	nDvcb := modulo11(cS)


	cCB   := SubStr(cS, 1, 4) + Alltrim(str(nDvcb)) + SubStr(cS,5,44)
	//Alterado Fabio Lemos - 11/2008



	cS1   := substr(cCB,1,4) + substr(cCB,20,5)
	nDv1  := modulo10(cS1)
	cLD1  := substr(cS1,1,5) + "." + substr(cS1,6,4) + Alltrim(str(nDv1)) + '  '


	cS2	:= SubStr(cCB,25,10)
	nDv2:= modulo10(cS2)
	cLD2:= substr(cS2,1,5) + "." + substr(cS2,6,5) + Alltrim(str(nDv2))+ '  '


	cS3   := SubStr(cCB,35,10)
	nDv3  := modulo10(cS3)
	cLD3  := substr(cS3,1,5) + "." + substr(cS3,6,5) + Alltrim(str(nDv3)) + '   '


	cLD4  := SubStr(cCB,5,1)+ '   '


	cLD5  := SubStr(cCB,6,4) + SubStr(cCB,10,10)


	//Todas as partes da LD
	cLD	  := cLD1 + cLD2 + cLD3 + cLD4 + cLD5

	_cLinDig := cLD


	_cCodBar := cCB

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fCodBarCef   ³ Autor ³ Microsiga          ³ Data ³ 01/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DA CAIXA EC. C/ CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCodBarCef(cBanco,cAgencia,cConta,cDacCC,nNrBancario,nValor,dVencto)

	Local cValorFinal := strzero(int(nValor*100),10)
	Local nDvnn				:= 0
	Local nDvcb				:= 0
	Local nDv					:= 0
	Local cNN					:= ''
	Local cRN					:= ''
	Local cCB					:= ''
	Local cS					:= ''
	Local cFator      := strzero(dVencto - ctod("07/10/97"),4)
	Local cCampoLivre := substr(nNrBancario,1,10)+"0167870000004422"

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	cS:= cBanco + "9" + cFator + cValorFinal + cCampoLivre
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + Alltrim(str(nDvcb)) + SubStr(cS,5,44)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			  Campo 2			  Campo 3			  Campo 4		Campo 5
	//	AAABC.DDDDX		EEEFF.FFFFFY 	FGGGG.GGHHHZ	K			    UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	  C = FIXO "9"
	//	DDDD = Codigo cedente padrao santander
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	cS1   := cBanco + "9" + substr(cCampoLivre,1,5)
	nDv1  := modulo10(cS1)
	cLD1  := substr(cS1,1,5) + "." + substr(cS1,6,5) + Alltrim(str(nDv1)) + '  '

	// 	CAMPO 2:
	//	EEE = Restante codigo do cedente
	//	FFFFFFF = 7 Primeiros campos do Nosso Numero
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	// cedente 9000000011016787000000462

	cS2	:= substr(cCampoLivre,6,10)
	nDv2:= modulo10(cS2)
	cLD2:= substr(cS2,1,5) + "." + substr(cS2,6,6) + Alltrim(str(nDv2))+ '  '

	// 	CAMPO 3:
	//	GGGGGG = Restante do nosso numero
	//	H = IOS - somente para seguradora demais, fixo 0
	//	   III = Tipo modalidade carteira : 101 - cobranca simples com registro - 102 cobranca simp. sem reg - 201 - penhor
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	cS3   := substr(cCampoLivre,16,10)
	nDv3  := modulo10(cS3)
	cLD3  := substr(cS3,1,5) + "." + substr(cS3,6,5) + Alltrim(str(nDv3)) + '   '

	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cLD4  := AllTrim(Str(nDvcb))+ '   '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	cLD5  := cFator + cValorFinal
	cLD	  := cLD1 + cLD2 + cLD3 + cLD4 + cLD5
	_cLinDig := cLD
	_cCodBar := cCB

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fCodBarCef   ³ Autor ³ Microsiga          ³ Data ³ 01/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO BNB       C/ CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCodBarBnb(cBanco,cAgencia,cConta,cDacCC,nNrBancario,nValor,dVencto)

	Local cValorFinal := strzero(int(nValor*100),10)
	Local nDvnn				:= 0
	Local nDvcb				:= 0
	Local nDv					:= 0
	Local cNN					:= ''
	Local cRN					:= ''
	Local cCB					:= ''
	Local cS					:= ''
	Local cFator      := strzero(dVencto - ctod("07/10/97"),4)
	Local cCampoLivre := "019800019025" + SUBSTR(ALLTRIM(nNrBancario),1,8) + "50" + "000"

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	cS:= cBanco + "9" + cFator + cValorFinal + cCampoLivre
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + Alltrim(str(nDvcb)) + SubStr(cS,5,44)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			  Campo 2			  Campo 3			  Campo 4		Campo 5
	//	AAABC.DDDDX		EEEFF.FFFFFY 	FGGGG.GGHHHZ	K			    UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	  C = FIXO "9"
	//	DDDD = Codigo cedente padrao santander
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	cS1   := cBanco + "9" + substr(cCampoLivre,1,5)
	nDv1  := modulo10(cS1)
	cLD1  := substr(cS1,1,5) + "." + substr(cS1,6,5) + Alltrim(str(nDv1)) + '  '

	// 	CAMPO 2:
	//	EEE = Restante codigo do cedente
	//	FFFFFFF = 7 Primeiros campos do Nosso Numero
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	// cedente 9000000011016787000000462

	cS2	:= substr(cCampoLivre,6,10)
	nDv2:= modulo10(cS2)
	cLD2:= substr(cS2,1,5) + "." + substr(cS2,6,6) + Alltrim(str(nDv2))+ '  '

	// 	CAMPO 3:
	//	GGGGGG = Restante do nosso numero
	//	H = IOS - somente para seguradora demais, fixo 0
	//	   III = Tipo modalidade carteira : 101 - cobranca simples com registro - 102 cobranca simp. sem reg - 201 - penhor
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	cS3   := substr(cCampoLivre,16,10)
	nDv3  := modulo10(cS3)
	cLD3  := substr(cS3,1,5) + "." + substr(cS3,6,5) + Alltrim(str(nDv3)) + '   '

	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cLD4  := AllTrim(Str(nDvcb))+ '   '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	cLD5  := cFator + cValorFinal

	cLD	  := cLD1 + cLD2 + cLD3 + cLD4 + cLD5

	_cLinDig := cLD
	_cCodBar := cCB

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fCodBar³    Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCodBarBane(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
	Local cValorFinal := strzero(int(nValor*100),10)
	Private numboleta,fatorvcto,b_campo,codbarras,dv_barra,linedig,nDigito,dv_nnum,cbarra,pedaco,esc
	Private nPos	 := 0
	M->DV_NNUM   := SPACE(1)
	M->DV_BARRA  := SPACE(1)
	M->cBARRA    := ""
	M->ASBACE    := ""
	M->LineDig   := ""
	M->NumBoleta := ""
	M->nDigito   := ""
	M->Pedaco    := ""
	esc := CHR(27)
	* Preparacao Inicio
	height    := 2.5
	small_bar := 3.8                               && number of points per bar  3

	wide_bar := ROUND(small_bar * 2.25,0)          && 2.25 x small_bar

	//height    := 2.5  && 2
	//small_bar := 4.2                               && number of points per bar  3
	//wide_bar := ROUND(small_bar * 2.25,0)          && 2.25 x small_bar
	dpl := 60   //50                                 && dots per line 300dpi/6lpi = 50dpl
	nb := esc+"*c"+TRANSFORM(small_bar,'99')+"a"+Alltrim(STR(height*dpl))+"b0P"+esc+"*p+"+TRANSFORM(small_bar,'99')+"X"
	// Barra estreita
	wb := esc+"*c"+TRANSFORM(wide_bar,'99')+"a"+Alltrim(STR(height*dpl))+"b0P"+esc+"*p+"+TRANSFORM(wide_bar,'99')+"X"
	// Barra larga
	ns := esc+"*p+"+TRANSFORM(small_bar,'99')+"X"
	// Espaco estreito
	ws := esc+"*p+"+TRANSFORM(wide_bar,'99')+"X"
	// Espaco largo
	_TpBar := "25"
	If _TpBar == "25"
		// Representacao binaria dos numeros 1-Barras/Espacos largas (os)
		// 0-Barras/Espacos estreitas (os)
		char25 := {}
		AADD(char25,"10001")       && "1"
		AADD(char25,"01001")       && "2"
		AADD(char25,"11000")       && "3"
		AADD(char25,"00101")       && "4"
		AADD(char25,"10100")       && "5"
		AADD(char25,"01100")       && "6"
		AADD(char25,"00011")       && "7"
		AADD(char25,"10010")       && "8"
		AADD(char25,"01010")       && "9"
		AADD(char25,"00110")       && "0"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Layout para o Banco Brasil  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cFixo1   := "4329876543298765432987654329876543298765432"
	_cFixo2   := "21212121212121212121212"
	_cFixo3   := "765432765432765432765432"
	_cFixo4   := "212121212"
	_cFixo5   := "1212121212"
	** Montagem do Codigo de Barras
	_ValBol  := QtdComp(SE1->E1_VALOR)
	_fatvenc := Alltrim(Str(SE1->E1_VENCTO-CTOD("07/10/1997")))
	_Desc1 := 0.00
	_Desc2 := 0.00
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Formar a linha digitavel e o código de barras³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	M->NumBoleta := SE1->E1_IDCNAB
	M->FatorVcto := Str( ( SE1->E1_VENCTO - Ctod("07/10/1997") ),4 )
	M->ASBACE := Substr(M->NumBoleta,1,8) + PADL(Alltrim(cConta),11,"0") + "4" + "021"

	nTotal := 0
	nTotalGer := 0

	For nI:=1 To Len(M->ASBACE)
		nTotal := Val(Substr(M->ASBACE,nI,1)) * Val(Substr(_cFixo2,nI,1))
		If nTotal > 9
			nTotal := nTotal - 9
		EndIf
		nTotalGer += nTotal
	Next

	nResto := Mod(nTotalGer,10)

	If nResto = 0
		cDigito1 := "0"
	Else
		cDigito1 := Alltrim(Str(10 - nResto))
	EndIf

	M->ASBACE := M->ASBACE + cDigito1
	nTotal := 0
	nTotalGer := 0

	For nI:=1 To Len(M->ASBACE)
		nTotal := Val(Substr(M->ASBACE,nI,1)) * Val(Substr(_cFixo3,nI,1))
		nTotalGer += nTotal
	Next

	nResto := 1

	While nResto = 1

		nResto := Mod(nTotalGer,11)

		If nResto = 0
			cDigito2 := "0"
		ElseIf nResto = 1
			cDigito1 := Alltrim(Str(Val(cDigito1) + 1))
			If cDigito1 = "10"
				cDigito1 = "0"
			EndIf

			M->ASBACE := Substr(M->ASBACE,1,23)

			M->ASBACE := M->ASBACE + cDigito1

			nTotal := 0
			nTotalGer := 0

			For nI:=1 To Len(M->ASBACE)
				nTotal := Val(Substr(M->ASBACE,nI,1)) * Val(Substr(_cFixo3,nI,1))
				nTotalGer += nTotal
			Next
		ElseIf nResto > 1
			cDigito2 := Alltrim(Str(11 - nResto))
		EndIf
	EndDo

	M->ASBACE := M->ASBACE + cDigito2

	M->cBARRA    := "0219" + M->FatorVcto + cValorFinal + M->ASBACE

	nTotal := 0
	nTotalGer := 0

	For nI:=1 To Len(M->cBARRA)
		nTotal := Val(Substr(M->cBARRA,nI,1)) * Val(Substr(_cFixo1,nI,1))
		nTotalGer += nTotal
	Next

	nResto := Mod(nTotalGer,11)

	If nResto = 0 .Or. nResto = 1 .Or. nResto = 10
		_cDigCodBar := "1"
	Else
		_cDigCodBar := Alltrim(Str(11 - nResto))
	EndIf

	M->cBARRA := Substr(M->cBARRA,1,4) + _cDigCodBar + Substr(M->cBARRA,5,40)

	_cCodBar := M->cBARRA

	M->LineDig := "021" + "9" + Substr(M->ASBACE,1,5)

	nTotal := 0
	nTotalGer := 0

	For nI:=1 To Len(M->LineDig)
		nTotal := Val(Substr(M->LineDig,nI,1)) * Val(Substr(_cFixo4,nI,1))
		If nTotal > 9
			nTotal := nTotal - 9
		Else
			nTotal := nTotal
		EndIf
		nTotalGer += nTotal
	Next

	If nTotalGer < 10
		nResto := nTotalGer
	Else
		nResto := Mod(nTotalGer,10)
	EndIf

	If nResto = 0
		_cDigLnDig := "0"
	Else
		_cDigLnDig := Alltrim(Str(10 - nResto))
	EndIf
	M->LineDig := M->LineDig + _cDigLnDig

	M->LineDig := Substr(M->LineDig,1,5) + "." + Substr(M->LineDig,6,5)

	_cCampo2 := Substr(M->ASBACE,6,10)

	nTotal := 0
	nTotalGer := 0

	For nI:=1 To Len(_cCampo2)
		nTotal := Val(Substr(_cCampo2,nI,1)) * Val(Substr(_cFixo5,nI,1))
		If nTotal > 9
			nTotal := nTotal - 9
		Else
			nTotal := nTotal
		EndIf
		nTotalGer += nTotal
	Next

	If nTotalGer < 10
		nResto := nTotalGer
	Else
		nResto := Mod(nTotalGer,10)
	EndIf

	If nResto = 0
		_cDigLnDig := "0"
	Else
		_cDigLnDig := Alltrim(Str(10 - nResto))
	EndIf

	_cCampo2 := _cCampo2 + _cDigLnDig

	_cCampo2 := Substr(_cCampo2,1,5) + "." + Substr(_cCampo2,6,6)

	_cCampo3 := Substr(M->ASBACE,16,10)

	nTotal := 0
	nTotalGer := 0

	For nI:=1 To Len(_cCampo3)
		nTotal := Val(Substr(_cCampo3,nI,1)) * Val(Substr(_cFixo5,nI,1))
		If nTotal > 9
			nTotal := nTotal - 9
		Else
			nTotal := nTotal
		EndIf
		nTotalGer += nTotal
	Next

	If nTotalGer < 10
		nResto := nTotalGer
	Else
		nResto := Mod(nTotalGer,10)
	EndIf

	If nResto = 0
		_cDigLnDig := "0"
	Else
		_cDigLnDig := Alltrim(Str(10 - nResto))
	EndIf

	_cCampo3 := _cCampo3 + _cDigLnDig
	_cCampo3 := Substr(_cCampo3,1,5) + "." + Substr(_cCampo3,6,6)

	_cCampo4 := Substr(M->cBARRA,5,1)

	_cCampo5 := M->FatorVcto + cValorFinal

	M->LineDig := M->LineDig + Space(2) + _cCampo2 + Space(2) + _cCampo3 + Space(2) + _cCampo4 + Space(2) + _cCampo5

	_cLinDig := M->LineDig

	/*	M->B_Campo := _cBanco + _cMoeda + M->FatorVcto

	M->B_Campo := M->B_Campo + StrZero((SE1->E1_VALOR*100),10)

	//	M->B_Campo := M->B_Campo + Left(M->Numboleta,11) + "3132" + "00190798" + "17"
	M->B_Campo := M->B_Campo + Left(M->Numboleta,11) + Substr(SE1->E1_AGEDEP,1,4)+strzero(Val(Substr(SE1->E1_CONTA,1,4)),8,0) + "176"
	//Calculo do Digito do Codigo de Barras
	BarraDV()
	//Compor a barra com o Digito verificador
	M->CodBarras := _cBanco + _cMoeda + M->DV_BARRA + M->FatorVcto

	M->CodBarras := M->CodBarras + StrZero((SE1->E1_VALOR*100),10)

	M->CodBarras := M->CodBarras + Left(M->Numboleta,11) + Substr(SE1->E1_AGEDEP,1,4)+strzero(Val(Substr(SE1->E1_CONTA,1,4)),8,0) + "176"
	//Montar a Linha Digitavel da Boleta
	MontaLinha()
	_cCodBar := M->CodBarras



	_cLinDig := M->LineDig*/
	// Monta String do codigo de barras propriamente dito
	_code := ""
	If _TpBar == "25"
		// Intercala a referencia binaria dos numeros aos pares, pois nesse tipo
		// os numeros das posicoes impares serao escritos em barras largas e barras
		// estreitas e os numeros das posicoes pares serao escritos com espacos largos
		// e espacos estreitos.
		_cBar := _cCodBar
		For _nX := 1 to 43 Step 2 && 44 porque o meu cod.possue 44 numeros
			_nNro := VAl(Substr(_cBar,_nx,1))
			If _nNro == 0
				_nNro := 10
			EndIf
			_cBarx := char25[_nNro]
			_nNro := VAl(Substr(_cBar,_nx+1,1))
			If _nNro == 0
				_nNro := 10
			EndIf
			_cBarx := _cBarx + char25[_nNro]

			For _nY := 1 to 5
				If Substr(_cBarx,_nY,1) == "0"
					// Uso Barra estreita
					_code := _code + nb
				Else
					// Uso Barra larga
					_code := _code + wb
				EndIf
				If Substr(_cBarx,_nY+5,1) == "0"
					// Uso Espaco estreito
					_code := _code + ns
				Else
					// Uso Espaco Largo
					_code := _code + ws
				EndIf
			Next
		Next
		_code := nb+ns+nb+ns+_code+wb+ns+nb
		// Guarda de inicio == Barra Estr+Esp.Estr+Barra Estr+Esp.Estr
		// Guarda de Fim    == Barra Larga +Esp.Estr+Barra Estr
		// Estes devem ser colocados antes e depois do codigo montado
	EndIf
Return

Static Function DigConta(_cParam)
	Local _cRet
	Local _cFixo := "121212121212121212121212"

	nTotal := 0
	nTotalGer := 0

	For nI:=1 To Len(_cParam)
		nTotal := Val(Substr(_cParam,nI,1)) * Val(Substr(_cFixo,nI,1))
		If nTotal > 9
			nTotal := Val(Substr(Alltrim(Str(nTotal)),1,1)) * Val(Substr(Alltrim(Str(nTotal)),1,2))
		Else
			nTotal := nTotal
		EndIf
		nTotalGer += nTotal
	Next

	nResto := Mod(nTotalGer,10)

	If nResto > 9
		_cRet := "0"
	Else
		_cRet := Alltrim(Str(10 - nResto))
	EndIf

Return(_cRet)


Static function LimpaFlag()

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSeek(xFilial("SE1") + MV_PAR01 + MV_PAR03, .T.)

	ProcRegua(RecCount())

	While SE1->(!Eof()) .And. SE1->E1_NUM <= MV_PAR04

		IncProc("Limpando Flag.." )

		Reclock("SE1", .F.)
		SE1->E1_OK := Space(2)
		MsUnlock()

		DbSkip()

	EndDo

Return()

Static Function BOLMARK()

	If !Marked("E1_OK")
		RecLock("SE1",.F.)
		SE1->E1_OK := ''
		MsUnLock()
	EndIf

Return()

//----------------------------------------------------------------------------------------------
Static Function fCodBaITAU(cBanco,cAgencia,cConta,cDacCC,nValor,dVencto,cCart,cCodCli,nUltNN)

	Local nDvnn			:= 0
	Local cNN			:= ''
	Local cRN			:= ''
	Local cCB			:= ''
	Local cNN_SemDig    := ''
	Private cDacBarra   

	cConta := SubStr(cConta, 1, 5)

	//	cNN_SemDig := NNumSeq(cBanco, cAgencia, cConta, nUltNN)      
	//	cNN   := cCart + cNN_SemDig
	If cCart = "126" .Or. cCart = "131" .Or. cCart = "145" .Or. cCart = "150" .Or. cCart = "168"
		nDvnn := CodDac(nTipoNNumero, cCart + cNroDoc )// cNroDoc) // digito verifacador 
	Else
		nDvnn := CodDac(nTipoNNumero, cAgencia + cConta + cCart + cNroDoc) //modulo11(cAgencia + cConta + cCart + cNroDoc )//cNroDoc) // digito verifacador 
	EndIf                                   

	//cNN     += '-' + AllTrim(Str(nDvnn))
	cNroDoc += '-' + AllTrim((nDvnn))
	cCB   := CodBarraItau(cCart, cBanco, "9", Str(nValor), cNroDoc, cAgencia, cConta, cCodCli, dVencto, cDacCC);

	_cCodBar := cCB 
	_cLinDig   := RepNumer(cBanco, "9", cCart, cNroDoc, cDocumento, dVencto, ;
	cAgencia, cConta, cDacCC, cCodCli, Str(nValor))

Return

//----------------------------------------------------------------------------
Static Function RepNumer(cBanco, cMoeda, cCarteira, cNNumero, cSNumero, dDtVenc, ;
	cAgencia, cCCorrente, cDacCC, cCodCli, cValor)
	local cSeq1
	local cSeq2
	local cSeq3
	local cSeq4
	local cSeq5
	local cSeq6
	local cFatorVenc
	local cNossoNum 
	local cCCorrCmp

	cNossoNum  := SubStr(cNNumero, 1, 8)

	cCodCli    := padL(allTrim(cCodCli)		, 05, "0")
	cCCorrCmp  := cCCorrente 	
	cCCorrente := padL(allTrim(cCCorrente)	, 05, "0")
	cValor     := padL(allTrim(cValor)		, 10, "0") 

	cFatorVenc := FatorVenc( dDtVenc )  

	/*CAMPO 1 (AAABC.CCDDX):
	AAA = CóDIGO DO BANCO NA CâMARA DE COMPENSAçãO “021”
	B   = CóDIGO DA MOEDA "9" (*)
	CCC = CóDIGO DA CARTEIRA DE COBRANçA
	DD  = OS 2 PRIMEIROS DíGITOS DO NOSSO NúMERO
	X   = DAC QUE AMARRA O CAMPO 1 (ANEXO 3) (*)
	*/     

	CSEQ1 := AllTrim(CBANCO + CMOEDA + CCARTEIRA + SUBSTR(cNossoNum, 1, 2))
	CSEQ1 += AllTrim(CODDAC(nTipoRNumerica, CSEQ1))

	/*
	CAMPO 5 (UUUUVVVVVVVVVV)
	UUUU= FATOR DE VENCIMENTO
	VVVVVVVVVV= VALOR DO TíTULO (*)
	*/

	CSEQ5 := AllTrim(FatorVenc(dDtVenc )) + AllTrim(cValor)

	If cCarteira == '198' .Or. cCarteira == '107' .Or. cCarteira == '122' .Or.;
	cCarteira == '142' .Or. cCarteira == '143' .Or. cCarteira == '196' .Or. cCarteira == "174" 

		/*
		Campo 2 (DDDDD.DEEEEY)
		DDDDDD = O restante do Nosso Número (sem o DAC) 
		EEEE = Os 4 primeiros números do campo Seu Número (N.º Doc.)
		Y      = DAC que amarra o campo 2 (Anexo 3)
		*/

		cSeq2 := AllTrim(SubStr(cNossoNum, 3, 6) + SubStr(cSNumero, 1, 4))
		cSeq2 += AllTrim(CodDac(nTipoRNumerica, cSeq2))

		/*Campo 3 (EEEFF.FFFGHZ)
		EEE = 3 últimos dígitos do campo Seu Número (N.ºDoc.) 
		FFFFF = Código do Cliente (fornecido pelo Banco)
		G =DAC (Carteira/Nosso Número (sem o DAC) / Seu Número (sem o DAC) / Código do Cliente) 
		H = Zero
		Z = DAC que amarra o campo 3 (Anexo 3)
		*/  

		cSeq3 := SubStr(cSNumero, 5, 3)+;
		AllTrim(cCodCli)+CodDac(nTipoRNumerica, cCarteira + cNossoNum + cSNumero + cCodCli)+;
		"0"                            
		cSeq3 += CodDac(nTipoRNumerica, cSeq3)

	Else  

		/*		
		Campo 2 (DDDDD.DEFFFY)
		DDDDDD = Restante do Nosso Número 
		E      = DAC do campo [ Agência/Conta/Carteira/ Nosso Número ]
		FFF    = Três primeiros números que identificam a Agência 
		Y      = DAC que amarra o campo 2 (Anexo 3)
		*/       

		cSeq2 := SubStr(cNossoNum, 3, 6);                                          
		+ CodDac(nTipoRNumerica, cAgencia + cCCorrCmp + cCarteira + cNossoNum);
		+ SubStr(cAgencia, 1, 3)		
		cSeq2 += CodDac(nTipoRNumerica, cSeq2) 		  

		/*
		Campo 3 (FGGGG.GGHHHZ)
		F      = Restante do número que identifica a agência 
		GGGGGG = Número da conta corrente + DAC
		HHH    = Zeros ( Não utilizado ) 
		Z      = DAC que amarra o campo 3 (Anexo 3)                                      
		*/                                         

		cSeq3 := SubStr(cAgencia, 4, 1)+cCCorrente+CodDac(nTipoRNumerica,cAgencia+ cCCorrente)+"000"
		cSeq3 += CodDac(nTipoRNumerica, cSeq3)
	EndIf           

	/*
	Campo 4 (K)
	K = DAC do Código de Barras (Anexo 2)             01
	*/

	cSeq4 := cDacBarra 

	cSeq1 := SubStr(cSeq1, 1, 5) + "." + SubStr(cSeq1, 6, 5) 
	cSeq2 := SubStr(cSeq2, 1, 5) + "." + SubStr(cSeq2, 6, 6)
	cSeq3 := SubStr(cSeq3, 1, 5) + "." + SubStr(cSeq3, 6, 6)

Return cSeq1 + "  " + cSeq2 + "  " + cSeq3 + "  " + cSeq4 + "  " + cSeq5 

//----------------------------------------------------------------------------------------
static function CodBarraItau(cCarteira, cBanco, cMoeda, cValor, cNNumero, cAgencia;
	, cCCorrente, cCodCli, cDtVenc, cDacCC)

	Local cCodigo
	//Local cDacBarra
	Local cDacNNumero
	//Local cDacCC                          
	Local cFatorVenc   

	cValor := padL(allTrim(cValor), 10, "0") 
	cNNumero := SubStr(cNNumero, 1, 8)      

	If cCarteira == "126" .Or. cCarteira == "131" .Or. cCarteira == "146" .Or.;
	cCarteira == "150" .Or. cCarteira == "168"
		cDacNNumero := CodDac(nTipoNNumero, cCarteira + cNNumero)

	Else
		cDacNNumero := CodDac(nTipoNNumero, cAgencia + cCCorrente +cCarteira + cNNumero)

	EndIf

	cFatorVenc  := FatorVenc(cDtVenc)

	If cCarteira != '198' .And. cCarteira != '107' .And. cCarteira != '122' .And.;
	cCarteira != '142' .And. cCarteira != '143' .And. cCarteira != '196' .And. cCarteira != "174" 
		//01 a 03  03  9(03)  Código do Banco na Câmara de Compensação = '341' 
		//04 a 04  01  9(01)  Código da Moeda = '9'
		//05 a 05  01  9(01)  DAC código de Barras (Anexo 2) 
		//06 a 09  04  9(04)  Fator de Vencimento (Anexo 6)
		//10 a 19  10  9(08)  V(2) Valor 
		//20 a 22  03  9(03)  Carteira
		//23 a 30  08  9(08)  Nosso Número 
		//31 a 31  01  9(01)  DAC [Agência /Conta/Carteira/Nosso Número] (Anexo 4)
		//32 a 35  04  9(04)  N.º da Agência cedente 
		//36 a 40  05  9(05)  N.º da Conta Corrente
		//41 a 41  01  9(01)  DAC [Agência/Conta Corrente] (Anexo 3) 
		//42 a 44  03  9(03)  Zeros  

		cDacBarra 	:= CodDac(nTipoBarra, cBanco + cMoeda + cFatorVenc + cValor + cCarteira;
		+ cNNumero + cDacNNumero + cAgencia + cCCorrente + cDacCC + "000")             			 

		cCodigo 	:= cBanco + cMoeda + cDacBarra + cFatorVenc + cValor + cCarteira ;
		+ cNNumero + cDacNNumero + cAgencia + cCCorrente + cDacCC + "000"

	Else			

		/*
		01 a 03  03  9(3)  Código do Banco na Câmara de Compensação = „341. 
		04 a 04  01  9(1)  Código da Moeda = '9'
		05 a 05  01  9(1)  DAC do Código de Barras (Anexo 2) 
		06 a 09  04  9(4)  Fator de Vencimento (Anexo 6)
		10 a 19  10  9(8)  V(2) Valor 
		20 a 22  03  9(3)  Carteira
		23 a 30  08  9(8)  Nosso Número 
		31 a 37  07  9(7)  Seu Número (Número do Documento)
		38 a 42  05  9(5)  Código do Cliente (fornecido pelo Banco) 
		43 a 43  01  9(1)  DAC dos campos acima (posições 20 a 42 veja anexo 3)
		44 a 44  01  9(1)  Zero
		*/	         

		cDacCC      := CodDac(nTipoRNumerica, cBanco + cMoeda + cFatorVenc + cValor + cCarteira;
		+ cNNumero + cCodCli)

		cDacBarra 	:= CodDac(nTipoBarra, cBanco + cMoeda + cFatorVenc + cValor + cCarteira;
		+ cNNumero + cCodCli + cDacCC + "0")  

		cCodigo 	:= cBanco + cMoeda + cDacBarra +cFatorVenc + cValor + cCarteira;
		+ cNNumero + cCodCli + cDacCC + "0"

	EndIf  	    

return cCodigo

//----------------------------------------------------------------------------
static function CodDac(nTipo, cNumero) 
	local aNumero
	local nI
	local nDgSoma 
	local nTotal  := 0
	local nDigito
	local nMult                
	local cSoma

	if nTipo == nTipoBarra
		nDgSoma := 2       

		for nI := len(cNumero) to 1 Step -1
			nTotal += Val( SubStr(cNumero, nI, 1) ) * nDgSoma 
			nDgSoma += 1

			If nDgSoma == 10 
				nDgSoma := 2
			EndIf

		Next 

		nDigito := nTotal % 11

		nDigito := 11 - nDigito
		//OBS.: Se o resultado desta for igual a 0, 1, 10 ou 11, considere DAC = 1.
		If nDigito = 0 .Or. nDigito = 10 .Or. nDigito = 11 
			nDigito := 1
		EndIf

	ElseIf nTipo == nTipoNNumero .Or. nTipo == nTipoRNumerica

		nDgSoma := 2 
		For nI := len(cNumero) to 1 Step -1

			nMult = Val( SubStr(cNumero, nI, 1) ) * nDgSoma
			If nMult >=10                                                              
				cSoma := AllTrim(Str(nMult))
				nMult := Val(SubStr(cSoma, 1, 1)) + Val(Substr(cSoma, 2, 1)) 
			EndIf 

			nTotal  += nMult

			If nDgSoma = 1 
				nDgSoma := 2
			Else
				nDgSoma := 1
			EndIf

		Next 		  

		nDigito := nTotal % 10
		nDigito := 10 - nDigito	 

		If nDigito = 10
			nDigito := 0
		EndIf

	EndIf

Return AllTrim(Str(nDigito))

//-------------------------------------------------------------------------
Static Function FatorVenc(dDtVenc)
	local cFator := "0000"

	cFator := strzero(dDtVenc - ctod("07/10/97"),4)

Return cFator    

//-------------------------------------------------------------------------
Static Function RelaNotas() 
	Local cNota 	:= ""
	Local cAlias 	:= GetNextAlias() 
	Local nContador := 0

	If AllTrim(SE1->E1_TIPO) == 'FT' .AND. SE1->E1_FATURA != ""
		BeginSql alias cAlias
			SELECT E1_NUM, E1_VALOR, E1_EMISSAO, E1_VENCREA, A1_NOME
			FROM %table:SE1% SE1
			JOIN %table:SA1% SA1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA 
			WHERE SE1.%notDel%
			AND E1_FILIAL = %xfilial:SE1% 
			AND E1_FATURA = %EXP:SE1->E1_NUM%
			AND E1_FATPREF = %EXP:SE1->E1_PREFIXO%

		EndSql   
		aRelaNotas := {}

		(cAlias)->(DbGoTop())
		While !(cAlias)->(Eof())
			If cNota != ""
				cNota += ", "
			EndIf	

			cNota += (cAlias)->E1_NUM 
			aAdd(aRelaNotas, {(cAlias)->E1_NUM, (cAlias)->E1_VALOR ;
			, (cAlias)->E1_EMISSAO, (cAlias)->E1_VENCREA;
			, (cAlias)->A1_NOME})

			(cAlias)->(DbSkip())
			nContador := 1
		EndDo
	Else
		cNota += "   "+SE1->E1_NUM
	EndIf

Return cNota