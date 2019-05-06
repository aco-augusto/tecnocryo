User Function Sched003()
Local cMyEmp   := "01"
Local cMyFil   := "0201"
Local aUsu     := {}
Local cBanco   := ""
Local cAgencia := ""
Local cConta   := "" //033 - 3442-8 - 13002487-6
Local oBolSan

	ConOut("Iniciando U_Sched003(" + cMyEmp + "," + cMyFil + ")")	
	
	RPCSetType(3)
	RPCSetEnv(cMyEmp,cMyFil)

	cBanco   := PadR("033", TamSX3("A6_COD")[1])
	cAgencia := PadR("3442", TamSX3("A6_AGENCIA")[1])
	cConta   := PadR("13002487", TamSX3("A6_NUMCON")[1])
	
	SA6->(DbSetOrder(1))
	SEE->(DbSetOrder(1))
	SA1->(DbSetOrder(1))
	SE1->(DbSetOrder(2))
	SF2->(DbSetOrder(1))		
	
	If SA6->(DbSeek(xFilial("SA6") + cBanco + cAgencia + cConta))
		if SEE->(DbSeek(xFilial("SEE") + SA6->(A6_COD + A6_AGENCIA + A6_NUMCON + "101") ))
			SF2->(DbGoTop())
	
			While SF2->(!Eof())
				If SF2->F2_TIPO == "N" .And. !Empty(SF2->F2_CHVNFE) .And. Empty(SF2->F2_CHVCLE) .And. !Empty(SF2->F2_DUPL) .And. SF2->F2_YSCHBOL == "S" .And. SF2->F2_YBOLENV <> "S"
					If SA1->(DbSeek(xFilial("SA1") + SF2->(F2_CLIENTE + F2_LOJA)))
						If !Empty(SA1->A1_EMAIL)
							If SE1->(DbSeek(xFilial("SE1") + SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DUPL)))
								While SE1->(!Eof()) .And. xFilial("SE1") + SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SF2") + SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DUPL)
									If AllTrim(SE1->E1_ORIGEM) == "MATA460" .And. Empty(SE1->E1_PORTADO)
										oBolSan := TWBolSantan():New()
										oBolSan:PrepTit()//Grava banco agencia conta e gera nosso numero
										oBolSan:Preparar()
										oBolSan:Montar()
										oBolSan:SalvarPDF()
										If oBolSan:Enviar()
											If SF2->F2_YBOLENV != "S"
												RecLock("SF2")
													SF2->F2_YBOLENV := "S"
												SF2->(MsUnlock())
											End If
										End If
									End If
									SE1->(DbSkip())
								End 
							End If
						End If
					End If
				End If
				SF2->(DbSkip())
			End
		End If	
	End If
	
	ConOut("Fechando U_Sched003(" + cMyEmp + "," + cMyFil + ")")	
	RpcClearEnv()
Return
/*
*/