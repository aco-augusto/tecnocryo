#include 'protheus.ch'
#include 'parmtype.ch'
#include 'msobject.ch'

//  CADASTROS: Inclus�o manual
//  A1_COND
//	ZZ1_COD		- C�digo da Amarra��o
//	ZZ1_PRDINT	- Produto Interno (de aplica��o)
//	ZZ1_PRDEXT	- Produto Externo (Cobran�a de Loca��o)
//	A1_YDIAFEC	- Dia para fechamento da fatura de alugu�l - Cadastro de Cliente

//  MOVIMENTA��ES: Ser� gerado por procedimento mensal e ou movimenta��o.
//	ZZ2_CODLOC	- C�digo de Loca��o
//	ZZ2_CLIENTE	- C�digo do Cliente
//	ZZ2_LOJA	- C�digo da Filial (Loja)
//	ZZ2_SERIE	- S�rie da NF de Remessa
//	ZZ2_NOTREM	- Nota Fiscal de Remessa
//	ZZ2_PRDAPL	- C�digo Produto Aplicado
//	ZZ2_QTDAPL 	- Quantidade Remessa
//	ZZ2_QTDDEV 	- Quantidade Devolvida
//	ZZ2_DTAAPL	- Data de Aplica��o / Remessa
//	ZZ2_ULTPED	- C�digo do �ltima Pedido para cobran�a do aluguel
//	ZZ1_GRPAMA	- Grupo de Amarra��o
//	ZZ1_METINC	- Metodo de Inclusao (M=Manual, A=Autom�tico)
//	ZZ1_ULTATU	- Data da �ltima atualiza��o
//	
//	AMARRA��ES: As movimenta��es ser�o vinculadas pelo c�digo de loca��o, para cada ocorr�ncia
//	C6_YCODLOC	- C�digo da Loca��o - Pedido
//	E1_YCODLOC	- C�digo da Loca��o - T�tulos
//	D2_YCODLOC	- C�digo da Loca��o - Nota de Remessa
//	D1_YCODLOC	- C�digo da Loca��o - Nota de Retorno

// Parametros da fun��o Parambox()
// -------------------------------
// 1 - < aParametros > - Vetor com as configura��es
// 2 - < cTitle >      - T�tulo da janela
// 3 - < aRet >        - Vetor passador por referencia que cont�m o retorno dos par�metros
// 4 - < bOk >         - Code block para validar o bot�o Ok
// 5 - < aButtons >    - Vetor com mais bot�es al�m dos bot�es de Ok e Cancel
// 6 - < lCentered >   - Centralizar a janela
// 7 - < nPosX >       - Se n�o centralizar janela coordenada X para in�cio
// 8 - < nPosY >       - Se n�o centralizar janela coordenada Y para in�cio
// 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
//10 - < cLoad >       - Nome do perfil se caso for carregar
//11 - < lCanSave >    - Salvar os dados informados nos par�metros por perfil
//12 - < lUserSave >   - Configura��o por usu�rio

// Caso alguns par�metros para a fun��o n�o seja passada ser� considerado DEFAULT as seguintes abaixo:
// DEFAULT bOk   := {|| (.T.)}
// DEFAULT aButtons := {}
// DEFAULT lCentered := .T.
// DEFAULT nPosX  := 0
// DEFAULT nPosY  := 0
// DEFAULT cLoad     := ProcName(1)
// DEFAULT lCanSave := .T.
// DEFAULT lUserSave := .F.

//If ParamBox(aParamBox,"Teste Par�metros...",@aRet)
//   For i:=1 To Len(aRet)
//      MsgInfo(aRet[i],"Op��o escolhida")
//   Next 
//Endif
//
//Return
// Tipo 1 -> MsGet()
//           [2]-Descricao
//           [3]-String contendo o inicializador do campo
//           [4]-String contendo a Picture do campo
//           [5]-String contendo a validacao
//           [6]-Consulta F3
//           [7]-String contendo a validacao When
//           [8]-Tamanho do MsGet
//           [9]-Flag .T./.F. Parametro Obrigatorio ?

//aAdd(aParamBox,{2,"Informe o m�s",1,aCombo,50,"",.F.})
// Tipo 2 -> Combo
//           [2]-Descricao
//           [3]-Numerico contendo a opcao inicial do combo
//           [4]-Array contendo as opcoes do Combo
//           [5]-Tamanho do Combo
//           [6]-Validacao
//           [7]-Flag .T./.F. Parametro Obrigatorio ?
// Cuidado, h� um problema nesta op��o quando selecionado a 1� op��o.

//aAdd(aParamBox,{3,"Mostra deletados",1,{"Sim","N�o"},50,"",.F.})
// Tipo 3 -> Radio
//           [2]-Descricao
//           [3]-Numerico contendo a opcao inicial do Radio
//           [4]-Array contendo as opcoes do Radio
//           [5]-Tamanho do Radio
//           [6]-Validacao
//           [7]-Flag .T./.F. Parametro Obrigatorio ?
//  Caso alguns par�metros para a fun��o n�o seja passada ser� considerado DEFAULT as seguintes abaixo:
//	DEFAULT bOk   		:= { || .T. }
//	DEFAULT aButtons 	:= {}
//	DEFAULT lCentered 	:= .T.
//	DEFAULT nPosX  		:= 0
//	DEFAULT nPosY  		:= 0
//	DEFAULT cLoad     	:= ProcName( 1 )
//	DEFAULT lCanSave 	:= .T.
//	DEFAULT lUserSave 	:= .F.


User function TECFAT07()

	Local aParamBox		:= {}

	Private _QRYSB6

	Private _cCliDE 	:= aRet[01]
	Private _cCliATE 	:= aRet[02]
	Private _cProdDE 	:= aRet[03]
	Private _cProdATE	:= aRet[04]
	Private _cCondPgt	:= aRet[05]
	Private _cTabPrc 	:= aRet[06]

	aAdd(aParamBox,{ 1, "Cliente  DE: "			,, PesqPict("SA1","A1_COD")		,'VAZIO() .OR. ExistCpo("SA1",1,xFilial("SA1")+MV_PAR01)',"SA1", .T., TamSx3("A1_COD")[2]+TamSx3("A1_LOJA")[2],.F.}) // Cliente DE
	aAdd(aParamBox,{ 1, "Cliente AT�: "			,, PesqPict("SA1","A1_COD")		,'ExistCpo("SA1",1,xFilial("SA1")+MV_PAR01)'			 ,"SA1", .T., TamSx3("A1_COD")[2]+TamSx3("A1_LOJA")[2],.T.}) // Cliente AT�
	aAdd(aParamBox,{ 1, "Produto  DE: "			,, PesqPict("SB1","B1_COD")		,'VAZIO() .OR. ExistCpo("SB1")'							 ,"SB1", .T., TamSx3("B1_COD")[2]					  ,.F.}) // Produto DE
	aAdd(aParamBox,{ 1, "Produto AT�: "			,, PesqPict("SB1","B1_COD")		,'ExistCpo("SB1")'										 ,"SB1", .T., TamSx3("B1_COD")[2]					  ,.T.}) // Produto AT�
	aAdd(aParamBox,{ 1, "Condi��o Pagamento: "	,, PesqPict("SA1","A1_COND")	,'VAZIO() .OR. ExistCpo("SE4")'							 ,"SE4", .T., TamSx3("A1_COND")[2]					  ,.F.}) // Produto DE
	aAdd(aParamBox,{ 1, "Tabela de Pre�o: "		,, PesqPict("SA1","A1_TABELA")	,'VAZIO() .OR. ExistCpo("SE4")'							 ,"SE4", .T., TamSx3("A1_TABELA")[2]				  ,.F.}) // Produto AT�

	IF ParamBox( aParamBox, "Teste Par�metros...", @aRet )

		_cCliDE  := aRet[01]
		_cCliATE := aRet[02]
		_cProdDE := aRet[03]
		_cProdATE:= aRet[04]
		_cCondPgt:= aRet[05]
		_cTabPrc := aRet[06]

		_QRYSB6 	:= GetNextAlias()

		LjMsgRun( 'Preparando dados...',, { || FAT07Temporario() } ) //Gera arquivo tempor�rio com as informa��es consolidadas de remessa e retorno do per�odo
		Processa( { || FAT07Historico() }, 'Atualizando hist�rico...' ) //Atualiza hist�rico do cliente com as informa��es consolidadas

		IF Select( _QRYSB6 ) > 0
			( _QRYSB6 ) -> ( dbCloseArea() )
		ENDIF

	ENDIF

return

Static Function FAT07Temporario()

	BeginSql Alias _QRYSB6
//  MOVIMENTA��ES: Ser� gerado por procedimento mensal e ou movimenta��o.
//	ZZ2_CODLOC	- C�digo de Loca��o
//	ZZ2_CLIENTE	- C�digo do Cliente
//	ZZ2_LOJA	- C�digo da Filial (Loja)
//	ZZ2_SERIE	- S�rie da NF de Remessa
//	ZZ2_NOTREM	- Nota Fiscal de Remessa
//	ZZ2_PRDAPL	- C�digo Produto Aplicado
//	ZZ2_QTDAPL 	- Quantidade Remessa
//	ZZ2_QTDDEV 	- Quantidade Devolvida
//	ZZ2_DTAAPL	- Data de Aplica��o / Remessa
//	ZZ2_ULTPED	- C�digo do �ltima Pedido para cobran�a do aluguel
//	ZZ1_GRPAMA	- Grupo de Amarra��o
//	ZZ1_METINC	- Metodo de Inclusao (M=Manual, A=Autom�tico)
//	ZZ1_ULTATU	- Data da �ltima atualiza��o
		SELECT 
		B6_CLIFOR ZZ2_CLIENTE, B6_LOJA ZZ2_LOJA, B6_PRODUTO ZZ2_PRDAPL, MIN(B6_EMISSAO) PRI_REMESSA, MAX(B6_EMISSAO) ULT_REMESSA, SUM( B6_QUANT ) ZZ2_QTDAPL, MAX(B6_PRUNIT) B6_PRUNIT --COUNT( DISTINCT B6_DOC )
		FROM 
		SB6010 SB6
		WHERE
		SB6.D_E_L_E_T_ 		= '' 			AND
		SB6.B6_FILIAL 		= '0101' 		AND
		SB6.B6_CLIFOR BETWEEN '000000000'	AND 'ZZZZZZZZZ' AND
		SB6.B6_LOJA	  BETWEEN '0000'		AND 'ZZZZ'		AND
		SB6.B6_LOCAL		= '01'			AND
		SB6.B6_SALDO 		> 0				AND
		SB6.B6_PODER3		= 'R'			AND
		SB6.B6_TES 		   IN ( '757','760' )
		GROUP BY B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_LOCAL
		;	
	EndSql

Return









