#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include 'totvs.ch'
function u_MA030ROT() 

	Local _aRot := {}

	//	ADD OPTION _aRot TITLE 'Loca��es' ACTION "MsgRun('Aguarde processando loca��es...','Central de Loca��es', {|| u_FAT8Central() })" OPERATION 2 ACCESS 0
	AADD(_aRot, {"Loca��es", "u_FAT8Central"	, 0, 6, 0, Nil } )

return _aRot

//User Function CRMA980()
//
//	Local aParam 	:= PARAMIXB
//	Local xRet 		:= .T.
//	Local oObj 		:= ""
//	Local cIdPonto 	:= ""
//	Local cIdModel 	:= ""
//	Local lIsGrid 	:= .F.
//	Local nLinha 	:= 0
//	Local nQtdLinhas:= 0
//	Local cMsg 		:= ""
//
//	If aParam <> NIL
//
//		oObj 		:= aParam[1]
//		cIdPonto 	:= aParam[2]
//		cIdModel 	:= aParam[3]
//		lIsGrid 	:= (Len(aParam) > 3)
//
//		//		If cIdPonto == "MODELPOS"
//		//			cMsg := "Chamada na valida��o total do modelo." + CRLF
//		//			cMsg += "ID " + cIdModel + CRLF
//		//
//		//			xRet := ApMsgYesNo(cMsg + "Continua?")
//
//		//		ElseIf cIdPonto == "FORMPOS"
//		//			cMsg := "Chamada na valida��o total do formul�rio." + CRLF
//		//			cMsg += "ID " + cIdModel + CRLF
//		//
//		//			If lIsGrid
//		//				cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
//		//				cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
//		//			Else
//		//				cMsg += "� um FORMFIELD" + CRLF
//		//			EndIf
//		//
//		//			xRet := ApMsgYesNo(cMsg + "Continua?")
//
//		//		ElseIf cIdPonto == "FORMLINEPRE"
//
//		//			If aParam[5] == "DELETE"
//		//				cMsg := "Chamada na pr� valida��o da linha do formul�rio. " + CRLF
//		//				cMsg += "Onde esta se tentando deletar a linha" + CRLF
//		//				cMsg += "ID " + cIdModel + CRLF
//		//				cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
//		//				cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
//		//				xRet := ApMsgYesNo(cMsg + " Continua?")
//		//			EndIf
//
//		//		ElseIf cIdPonto == "FORMLINEPOS"
//
//		//			cMsg := "Chamada na valida��o da linha do formul�rio." + CRLF
//		//			cMsg += "ID " + cIdModel + CRLF
//		//			cMsg += "� um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
//		//			cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
//		//			xRet := ApMsgYesNo(cMsg + " Continua?")
//
//		//		ElseIf cIdPonto == "MODELCOMMITTTS"
//		//			ApMsgInfo("Chamada ap�s a grava��o total do modelo e dentro da transa��o.")
//
//		//		ElseIf cIdPonto == "MODELCOMMITNTTS"
//		//			ApMsgInfo("Chamada ap�s a grava��o total do modelo e fora da transa��o.")
//
//		//		ElseIf cIdPonto == "FORMCOMMITTTSPRE"
//		//			ApMsgInfo("Chamada ap�s a grava��o da tabela do formul�rio.")
//
//		//		ElseIf cIdPonto == "FORMCOMMITTTSPOS"
//		//			ApMsgInfo("Chamada ap�s a grava��o da tabela do formul�rio.")
//
//		//		ElseIf cIdPonto == "MODELCANCEL"
//		//			cMsg := "Deseja realmente sair?"
//		//			xRet := ApMsgYesNo(cMsg)
//
//		If cIdPonto == "BUTTONBAR"
//			xRet := { {"Loca��es", "ANALITIC", { || u_FAT8Central() }}}
//		EndIf
//
//	EndIf
//
//Return xRet


User Function CRM980MDef()
	Local aRotina := {}
	//----------------------------------------------------------------------------------------------------------
	// [n][1] - Nome da Funcionalidade
	// [n][2] - Fun��o de Usu�rio
	// [n][3] - Opera��o (1-Pesquisa; 2-Visualiza��o; 3-Inclus�o; 4-Altera��o; 5-Exclus�o)
	// [n][4] - Acesso relacionado a rotina, se esta posi��o n�o for informada nenhum acesso ser� validado
	//----------------------------------------------------------------------------------------------------------
	aAdd(aRotina,{"Loca��es","u_FAT8Central",MODEL_OPERATION_VIEW,0})
Return( aRotina )