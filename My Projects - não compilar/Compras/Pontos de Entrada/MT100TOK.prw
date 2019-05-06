User Function MT100TOK()
Local lRet       := ParamIXB[1]
Local nPosPedido := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_PEDIDO" })
Local nPosItemPC := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_ITEMPC" })
Local nTotL      := Len(aCols)

	If cTipo == "N"
		For l := 1 To nTotL
			If (Empty(aCols[l,nPosPedido]) .Or. Empty(aCols[l,nPosItemPC]))
				Aviso("MT100TOK","Informe os pedido(s) de compra.",{"Ok"})
				lRet := .F.
				Exit
			EndIf
		Next l
	EndIf
Return lRet