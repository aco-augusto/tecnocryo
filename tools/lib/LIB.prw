/*/
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Autor	 � WLADIMIR ILLIUSHENKO                        � Data � 04/05/01 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � BIBLIOTECA DE FUNCOES E PROCEDIMENTOS GERAIS                  ���
����������������������������������������������������������������������������Ĵ��
��� Obs		 � Todas as funcoes aqui escritadas devem conter comentario      ���
���          � sobre sua meta, parametros e um exemplo de sua utilizacao.    ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������/*/

#Include "rwmake.ch"
#Include "topconn.ch"
#Include "ap5mail.ch"
#Include "fileio.ch"
#Include "colors.ch"
#Include "TBiconn.ch"
#Include "Totvs.ch"
#Include "Protheus.ch"

#Define SAY PSAY
#Define DBOI_BagName 7
#Define DBOI_OrderCount 9

#xcommand DEFAULT <uVar1> := <uVal1> ;
[, <uVarN> := <uValN> ] => ;
<uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
[ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

#xcommand @ <nRow>, <nCol> BITMAP [ <oBmp> ] ;
[ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
[ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
[ <NoBorder:NOBORDER, NO BORDER> ] ;
[ SIZE <nWidth>, <nHeight> ] ;
[ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
[ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
[ <rClick: ON RIGHT CLICK> <uRClick> ] ;
[ <scroll: SCROLL> ] ;
[ <adjust: ADJUST> ] ;
[ CURSOR <oCursor> ] ;
[ <pixel: PIXEL>   ] ;
[ MESSAGE <cMsg>   ] ;
[ <update: UPDATE> ] ;
[ WHEN <uWhen> ] ;
[ VALID <uValid> ] ;
[ <lDesign: DESIGN> ] ;
=> ;
[ <oBmp> := ] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
<cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
[\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
[\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
<.adjust.>, <oCursor>, <cMsg>, <.update.>,;
<{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.> )



/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Envia e-mail                                                             �
�                                                                          �
� SINTAXE: U_SENDMAIL(<cFROM>,<aTO>,[<aCC>],[<aCCO>],<cSUBJECT>,<cTexto>   �
�                     [,<aAnexo>[,<lFormTexto>]])                          �
�                                                                          �
� EX:                                                                      �
�     U_SENDMAIL("from@abc",{"to@abc"},,,"TESTE","Teste...",,.F.)          �
�     U_SENDMAIL("from@abc",{"to@abc"},{"cc@abc"),{"cco@abc"},"TESTE",     �
�                "Teste...",,.T.)                                          �
�     U_SENDMAIL("from@abc",{"to@abc"},{"cc@abc"),{"cco@abc"},"TESTE",     �
�                "Teste...",{"C:\CARTA.DOC","S:\MODELO.PDF"})              �
����������������������������������������������������������������������������*/
User Function SendMail(_cFROM,_aTO,_aCC,_aCCO,_cSUBJECT,_cBODY,_aAnexo,_lFormTexto,_lMailProt)

Local _aArea     := GetArea()
Local _cServidor := ""
Local _cConta    := ""
Local _cSenha    := ""
Local _cErro     := ""
Local _lResult   := .F.

_aTO           := iif(valtype(_aTO)<>"A",{},_aTO)
_aCC           := iif(valtype(_aCC)<>"A",{},_aCC)
_aCCO          := iif(valtype(_aCCO)<>"A",{},_aCCO)
_aAnexo        := iif(valtype(_aAnexo)<>"A",{},_aAnexo)
_lFormTexto    := iif(valtype(_lFormTexto)<>"L",.F.,_lFormTexto)
_lMailProt	   := iif(valtype(_lMailProt)<>"L",.T.,_lMailProt)
_cServidor     := iif(_lMailProt,alltrim(GETMV("MV_RELSERV")), alltrim(GETMV("MV_WFSMTP")))
_cConta        := iif(_lMailProt,alltrim(GETMV("MV_RELACNT")), alltrim(GETMV("MV_WFMAIL")))
_cSenha        := iif(_lMailProt,alltrim(GETMV("MV_RELPSW")), alltrim(GETMV("MV_WFPASSW")))
_lAutentic     :=  GetMv("MV_RELAUTH",,.T.)
_cErro         := ""
CONNECT SMTP SERVER _cServidor ACCOUNT _cConta PASSWORD _cSenha RESULT _lResult
if _lResult
	// Autenticacao de e-mail
	if _lAutentic
		MailAuth(_cConta, _cSenha)
	endif
	_lResult := MailSend( _cConta, _aTO, _aCC, _aCCO, _cSUBJECT, _cBODY, _aAnexo, _lFormTexto )
endif
if !_lResult
	GET MAIL ERROR _cErro
endif

DISCONNECT SMTP SERVER

RestArea(_aArea)

Return {_lResult,_cErro}


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Testa se um determinado valor esta entre outros dois                     �
�                                                                          �
� SINTAXE: U_ENTRE(<aVals>,<xVal>)                                         �
�                                                                          �
� EX:                                                                      �
�     U_ENTRE({"a","c"},"b") -> .T.                                        �
�     U_ENTRE({"a","c"},"d") -> .F.                                        �
�     U_ENTRE({{"a","c"},{"d","f"}},"d") -> .T.                            �
�     U_ENTRE({{"a","c"},{"d","f"}},"g") -> .F.                            �
�     U_ENTRE({{1,3},{5,7}},4) -> .F.                                      �
�     U_ENTRE({{1,3},{5,7}},6) -> .T.                                      �
����������������������������������������������������������������������������
/*/
User Function Entre(_aValores,_xValor)

Local _lResult := .T.
Local _ni      := 0

&& Verifica se o segundo parametro existe
if (_lResult := Valtype(_xValor) <> "U")
	
	&& Verifica se o primeiro parametro he uma array
	if (_lResult := Valtype(_aValores) == "A")
		
		&& Verifica se a array possui dados
		if (_lResult := !empty(_aValores))
			
			&& Verifica se a array principal e uma array simples com dois elementos e tranforma ela em uma array dela mesma
			if len(_aValores)==2 .AND. Valtype(_aValores[1])==Valtype(_xValor) .AND. Valtype(_aValores[2])==Valtype(_xValor)
				_aValores := {_aValores}
			endif
			
			for _ni := 1 to len(_aValores)
				
				&& Verifica se cada elemento da array he uma nova array com dois elementos
				if (_lResult := (Valtype(_aValores[_ni]) == "A" .AND. len(_aValores[_ni]) == 2))
					
					&& Verifica se cada elemento da arry secundaria he do mesmo tipo do valor a ser comparado
					if (_lResult := (Valtype(_aValores[_ni][1]) == Valtype(_xValor) .AND. Valtype(_aValores[_ni][2]) == Valtype(_xValor)))
						
						&& Verifica se o valor principal se encontra entre os dois elementos da array secundaria atual
						_lResult := (_xValor >= _aValores[_ni][1]  .AND. _xValor <= _aValores[_ni][2])
					endif
				endif
				if _lResult
					exit
				endif
			next
		endif
	endif
endif

Return _lResult


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Retorno um numero alfanumero de documento livre no SD3 seguindo a        �
� sequencia alfabetica                                                     �
�                                                                          �
� SINTAXE: U_PROXDOCD3()                                                   �
����������������������������������������������������������������������������
/*/
User Function ProxDocD3()

Local _cQuery   := ""
Local _cPrefixo := "A"
Local _cDoc     := ""

do while empty(_cDoc) .AND. _cPrefixo <> "Z"
	_cQuery := "SELECT ISNULL(MAX(D3_DOC),'"+_cPrefixo+"00000') AS MAXREG "
	_cQuery += " FROM "+RetSqlName("SD3")+" SD3 WITH (NOLOCK)"
	_cQuery += " WHERE D3_FILIAL = '"+xFilial('SD3')+"'"
	_cQuery += " AND LEFT(SD3.D3_DOC,1) = '"+_cPrefixo+"'"
	_cQuery += " AND SD3.D_E_L_E_T_ = ''"
	DBUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
	if QRY->MAXREG = _cPrefixo+"ZZZZZ"
		_cPrefixo := soma1(_cPrefixo)
	else
		_cDoc := Soma1(QRY->MAXREG,6) // Obtem a proxima sequancia de documento
	endif
	QRY->(DBCloseArea())
enddo

Return _cDoc


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Solicita a passagem de uma senha ao usuario retornando .T. ou .F. quanto �
� a confirmacao da senha apos o limite de tentativas.                      �
�                                                                          �
� SINTAXE: U_SENHA(_cContraSenha, _cMsg, _nTentativas) -> .T./.F.          �
����������������������������������������������������������������������������
/*/
User Function Senha(_cContraSenha, _cMsg, _nTentativas)

Local _cSenha    := space(40)
Local _oDlg      := NIL
Local _nCont     := 0
Local _lResult   := .F.
Local _nCorFundo := RGB( 255, 255, 190 )

DEFAULT _cMsg        := "Senha"  /* define a mensagem a ser exibida na caixa de dialogo da senha */
DEFAULT _nTentativas := 1        /* define o numero minimo de tetativas de se digitar a senha correta */

if _nTentativas < 1
	_nTentativas := 1
endif

&&&& janela de senha
do while _nCont < _nTentativas .AND. !_lResult
	
	&& caixa de dialogo
	_cSenha := space(40)
	_oDlg   := MSDialog():New(000,000,180,350,_cMsg,,,,,CLR_BLACK,_nCorFundo,,,.T.)
	u_beep()
	&&@ 006,006 BITMAP RESOURCE "CHAVE2" SIZE 12,12 OF _oDlg PIXEL
	@ 006,006 BITMAP RESOURCE "CHAVE2" SIZE 12,12 PIXEL OF _oDlg
	@ 010,030 say "Senha de libera��o:" PIXEL OF _oDlg
	@ 019,030 get _cSenha PASSWORD SIZE 60,12 PIXEL OF _oDlg
	@ 030,120 Button "_Confirma..." Size /*Width*/047,/*Height*/013 PIXEL OF _oDlg  Action Close(_oDlg)
	Activate Dialog _oDlg CENTERED
	
	&& verifica se a senha e valida, ou seja, se e identica a contra-senha
	_nCont++
	if !( _lResult := (alltrim(_cSenha) == alltrim(_cContraSenha)) )
		MsgStop("Senha incorreta!","Senha")
	endif
enddo

Return(_lResult)


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Emite um beep                                                            �
����������������������������������������������������������������������������
/*/
User Function beep()
Tone(4000,3)
Return


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Retorna uma array com a Pilha de Procedimentos                           �
����������������������������������������������������������������������������
/*/
User Function AProc()

Local _aProc := {}
Local _ni    := 1

do while !empty(upper(alltrim(ProcName( _ni ))))
	aadd(_aProc, upper(alltrim(ProcName( _ni ))) )
	_ni++
enddo
Return _aProc


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Apaga arquivos temporarios                                               �
����������������������������������������������������������������������������
/*/
User Function ApagaTmps(_cAlias, _cArqTemp)

Local _cPathArq := ""
Local _cArquivo := ""
Local _ni		:= 0

if valtype(_cArqTemp)<>"C"
	
	&& nao foi passado o nome do arquivo portanto o sistema vai determina-lo pelo ALIAS
	_cAlias := iif(valtype(_cAlias)<>"C",Alias(),_cAlias)
	if Select(_cAlias) > 0
		_cPathArq := alltrim((_cAlias)->(DbInfo(10)))
		
		&& captura o nome do arquivo sem o path
		for _ni := len(_cPathArq) to 1 step -1
			if substr(_cPathArq,_ni,1) == "\"
				_cArquivo := substr(_cPathArq,_ni+1)
				_cArquivo := substr(_cArquivo,1,at(".",_cArquivo)-1)
				exit
			endif
		next
		
		&& fecha o alias antes de prosseguir com a exclusao dos arquivos temporarios
		(_cAlias)->(DBCloseArea())
	else
		Return
	endif
	
else
	_cArquivo := alltrim(substr(_cArqTemp,1,at(".",_cArqTemp)-1))
endif

&& apaga os arquivos temporarios
aeval(directory(left(_cArquivo,7)+"?.*"),{ |aFile| FErase(aFile[1])})

&& apaga todos os arquivos tempor�rios com mais de 3 dias de idade
_aSCs := directory("SC??????.*")
for _ni := 1 to len(_aSCs)
	
	&& verifica se o arquivo possui a idade necess�ria para exclus�o
	if ( date() - _aSCs[_ni][3] ) >= 2
		
		&& verifica se o arquivo se trata de um arquivo que deve ser exclu�do
		if upper(right(_aSCs[_ni][1],4))$".DBF, .CDX, .FPT, .LOG, .IDX, .MEM, .TXT" .OR. ( right(_aSCs[_ni][1],4) >= ".001" .AND. right(_aSCs[_ni][1],4) <= ".999" )
			FErase( _aSCs[_ni][1] )
		endif
	endif
next

Return


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Troca caracteres acentuados por caracteres sem acento                    �
����������������������������������������������������������������������������
/*/
User Function RmvAcentos(_cString)
_cString := strtran(_cString,"�","a") // ~a
_cString := strtran(_cString,"�","a") // 'a
_cString := strtran(_cString,"�","a") // `a
_cString := strtran(_cString,"�","a") // ^a
_cString := strtran(_cString,"�","A") // ~A
_cString := strtran(_cString,"�","A") // 'A
_cString := strtran(_cString,"�","A") // `A
_cString := strtran(_cString,"�","A") // ^A
_cString := strtran(_cString,"�","e") // 'e
_cString := strtran(_cString,"�","e") // `e
_cString := strtran(_cString,"�","e") // ^e
_cString := strtran(_cString,"�","E") // 'E
_cString := strtran(_cString,"�","E") // `E
_cString := strtran(_cString,"�","E") // ^E
_cString := strtran(_cString,"�","i") // 'i
_cString := strtran(_cString,"�","I") // 'I
_cString := strtran(_cString,"�","o") // 'o
_cString := strtran(_cString,"�","o") // `o
_cString := strtran(_cString,"�","o") // ~o
_cString := strtran(_cString,"�","o") // ^o
_cString := strtran(_cString,"�","O") // 'O
_cString := strtran(_cString,"�","O") // `O
_cString := strtran(_cString,"�","O") // ~O
_cString := strtran(_cString,"�","O") // ^O
_cString := strtran(_cString,"�","u") // 'u
_cString := strtran(_cString,"�","u") // `u
_cString := strtran(_cString,"�","u") // ..u
_cString := strtran(_cString,"�","U") // 'U
_cString := strtran(_cString,"�","U") // `U
_cString := strtran(_cString,"�","U") // ..U
_cString := strtran(_cString,"�","c") // ;c
_cString := strtran(_cString,"�","C") // ;C
_cString := strtran(_cString,"�",".") // o.
Return _cString


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Resulta em uma string a partir de uma array                              �
����������������������������������������������������������������������������
/*/
User Function fArrayToStr(_aArray, _lEmBlocos)

Local _cStr := ""
Local _ni   := 0

for _ni := 1 to len(_aArray)
	if _aArray[_ni] <> Nil
		if _lEmBlocos // Separ a string em blocos separados por ','
			_cStr += iif(empty(_cStr),"",",")+"'"+_aArray[_ni]+"'"
		else
			if Valtype(_aArray[_ni])=="A"
				_cStr += fArrayToStr(_aArray[_ni])
			else
				_cStr += _aArray[_ni]
			endif
		endif
	endif
next
return (_cStr)


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Retorna uma array com o nome, ordem e recno de todas as �reas abertas no �
� momento.                                                                 �
�                                                                          �
� SINTAXE: U_GTWORKAREA() -> {{_cAlias1,nIndex1,_nReno1},...}              �
�                                                                          �
����������������������������������������������������������������������������*/
User Function GtWorkArea()

Local _aAreas := {}
Local _ni     := 0
Local _cAlias := ""
Local _nIndex := 0
Local _nRecNo := 0

do while !empty(alias(_ni))
	_cAlias := alias(_ni)
	_nIndex := (_cAlias)->(IndexOrd())
	_nRecNo := (_cAlias)->(RecNo())
	aadd(_aAreas, {_cAlias, _nIndex, _nRecNo})
	_ni++
enddo
Return _aAreas


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Restaura uma array de Areas de Trabalho.                                 �
� Se o parametro Alias Especial for informado, somente est� area ser�      �
� retaurada.                                                               �
�                                                                          �
� SINTAXE: U_RTWORKAREA( _aAreas, _cAliasEspecial )                        �
�                                                                          �
����������������������������������������������������������������������������*/
User Function RtWorkArea( _aAreaAntiga, _cAliasEspecial )

Local _aAreaAtual := {}
Local _ni         := 0
Local _cAlias     := ""
Local _nIndex     := 0
Local _nRecNo     := 0
Local _nPos       := 0

&& Captura as �reas atualmente utilizadas
do while !empty(alias(_ni))
	_cAlias := alias(_ni)
	_nIndex := (_cAlias)->(IndexOrd())
	_nRecNo := (_cAlias)->(RecNo())
	aadd(_aAreaAtual, {_cAlias, _nIndex, _nRecNo})
	_ni++
enddo

&& Verifica se a �rea utilizada est� com a configura��o diferente
for _ni := 1 to len(_aAreaAntiga)
	if (_nPos := ascan(_aAreaAtual, {|a| a[1] == _aAreaAntiga[_ni,1]})) > 0 .AND. iif(ValType(_cAliasEspecial) == "C", _aAreaAtual[_nPos,1] == _cAliasEspecial,.T.) .AND. (_aAreaAtual[_nPos,2] <> _aAreaAntiga[_ni,2] .OR. _aAreaAtual[_nPos,3] <> _aAreaAntiga[_ni,3])
		(_aAreaAtual[_nPos,1])->(DBSetOrder(_aAreaAntiga[_ni,2]))
		(_aAreaAtual[_nPos,1])->(DBGoTo(_aAreaAntiga[_ni,3]))
	endif
next

Return


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Cria arquivo temporario de trabalho, conforme estrutura e arquivos de    �
� indices predefinidos pelos parametros.                                   �
�                                                                          �
� SINTAXE: U_OPENTRB(_aCampos, paIndex, pAlias)                            �
�                                                                          �
� Parametros                                                               �
�   _aCampos - Array com os campos a serem criados, no mesmo layout da...  �
�              ... funcao CriaTrab do Protheus.                            �
�   _aIndex  - Array de indices a criar, Campos do Alias                   �
�   _cAlias  - Nome do alias a criar.								       �
����������������������������������������������������������������������������*/
User Function OpenTrb(_aCampos, _aIndex, _cAlias)

Local _cTrab  := ""
Local _cIndex := ""
Local _cChave := ""
Local _ni     := 0

DEFAULT _aCampos := {}

if select(_cAlias) > 0
	(_cAlias)->(DBCloseArea())
endif

// Criando Area de Trabalho Temporaria com os campos passados
_cTrab := CriaTrab(_aCampos)

DBUseArea(.T., '', _cTrab, _cAlias, .F., .F.)

DBSelectArea(_cAlias)

// Criando indices para tabela temporaria
for _ni := 1 To Len(_aIndex)
	_cIndex := _cTrab + Chr(64 + _ni)
	_cChave := _aIndex[_ni]
	IndRegua(_cAlias, _cIndex, _cChave, , , "Criando Indice...")
next

(_cAlias)->(DBClearIndex())

for _ni := 1 To Len(_aIndex)
	_cIndex := _cTrab + Chr(64 + _ni)
	(_cAlias)->(DBSetIndex(_cIndex + OrdBagExt()))
next

return _cTrab


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Deletar todos os arquivos (indices e arquivos temporario) do alias       �
� passado como parametro na funcao.                                        �
�                                                                          �
� SINTAXE: U_CLOSETRB(_cAlias, _cNomArq)                                   �
�                                                                          �
� Parametros                                                               �
�   _cAlias   - Alias a fechar.                                            �
�   _cNomArq  - Nome do Arquivo de Trabalho.                               �
����������������������������������������������������������������������������*/
User Function CloseTrb(_cAlias, _cNomArq)

Local _cNomInd := ""
Local _nQtdInd := 0
Local _aIndic  := {}
Local _ni      := 0
Local _aArea   := GetArea()

DEFAULT _cAlias  := ""
DEFAULT _cNomArq := ""

if !empty(_cAlias)
	
	DBSelectArea(_cAlias)
	
	// Quantidade de Indices da tabela
	_cNomInd := (_cAlias)->(DBOrderInfo(DBOI_BagName))
	_cNomInd := left(_cNomInd, len(_cNomInd) - 1)
	
	// Nome Area Ativa
	_nQtdInd := (_cAlias)->(DBOrderInfo(DBOI_OrderCount)) - 1
	
	// Buscando todos os indices que o alias possui
	_aIndic := {}
	for _ni := 1 To _nQtdInd
		(_cAlias)->(DbSetOrder(_ni))
		aadd(_aIndic, (_cAlias)->(DBOrderInfo(DBOI_BagName)))
	next
	
	// Apagando Indices do Alias Temporario
	(_cAlias)->(DBCloseArea())
	
	for _ni := 1 to len(_aIndic)
		if file(_aIndic[_ni] + OrdBagExt())
			FErase(_aIndic[_ni] + OrdBagExt())
		endif
	next
	
else
	_cNomInd := _cNomArq
endif

// Deletando arquivo principal da Area Temporaria
if file(_cNomInd + GetDBExtension())
	FErase(_cNomInd + GetDBExtension())
endif

RestArea(_aArea)

return NIL


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------
��������������������������������������������������������������������������Ŀ
� Cria Registros no Dicion�rio de Perguntas do Protheus, similara a        �
� funcao PutSX1.                                                           �
����������������������������������������������������������������������������*/
User Function SetSx1(cGrupo, cOrdem, cPergunt, cPerSpa, cPerEng, cVar,;
cTipo, nTamanho, nDecimal, nPresel, cGSC, cValid,;
cF3, cGrpSxg, cPyme,;
cVar01, cDef01, cDefSpa1, cDefEng1, cCnt01,;
cDef02, cDefSpa2, cDefEng2,;
cDef03, cDefSpa3, cDefEng3,;
cDef04, cDefSpa4, cDefEng4,;
cDef05, cDefSpa5, cDefEng5,;
aHelpPor, aHelpEng, aHelpSpa, cHelp)

Local aArea := GetArea()
Local cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
Local lPort := .F.
Local lSpa  := .F.
Local lIngl := .F.

cPyme    := Iif( cPyme == Nil  , " ", cPyme  )
cF3      := Iif( cF3 == NIl    , " ", cF3    )
cGrpSxg  := Iif( cGrpSxg == Nil, " ", cGrpSxg)
cCnt01   := Iif( cCnt01 == Nil , " ", cCnt01 )
cHelp    := Iif( cHelp == Nil  , " ", cHelp  )

DBSelectArea("SX1")
DBSetOrder(1)

// Ajusta o tamanho do grupo. Ajuste emergencial para valida��o dos fontes.
// RFC - 15/03/2007
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

If !SX1->(DBSeek( cGrupo + cOrdem ))
	
	cPergunt := If(! "?" $ cPergunt .AND. ! Empty(cPergunt),Alltrim(cPergunt)+" ?", cPergunt)
	cPerSpa  := If(! "?" $ cPerSpa  .AND. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?", cPerSpa)
	cPerEng  := If(! "?" $ cPerEng  .AND. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?", cPerEng)
	
	Reclock("SX1", .T. )
	
	Replace X1_GRUPO   With cGrupo
	Replace X1_ORDEM   With cOrdem
	Replace X1_PERGUNT With cPergunt
	Replace X1_PERSPA  With cPerSpa
	Replace X1_PERENG  With cPerEng
	Replace X1_VARIAVL With cVar
	Replace X1_TIPO    With cTipo
	Replace X1_TAMANHO With nTamanho
	Replace X1_DECIMAL With nDecimal
	Replace X1_PRESEL  With nPresel
	Replace X1_GSC     With cGSC
	Replace X1_VALID   With cValid
	Replace X1_VAR01   With cVar01
	Replace X1_F3      With cF3
	Replace X1_GRPSXG  With cGrpSxg
	
	If Fieldpos("X1_PYME") > 0
		If cPyme != Nil
			Replace X1_PYME With cPyme
		Endif
	Endif
	
	Replace X1_CNT01 With cCnt01
	If cGSC == "C"               // Mult Escolha
		Replace X1_DEF01   With cDef01
		Replace X1_DEFSPA1 With cDefSpa1
		Replace X1_DEFENG1 With cDefEng1
		
		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2
		
		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3
		
		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4
		
		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	Endif
	
	Replace X1_HELP With cHelp
	
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	SX1->(MsUnLock())
Else
	
	lPort := ! "?" $ X1_PERGUNT .AND. ! Empty(SX1->X1_PERGUNT)
	lSpa  := ! "?" $ X1_PERSPA  .AND. ! Empty(SX1->X1_PERSPA)
	lIngl := ! "?" $ X1_PERENG  .AND. ! Empty(SX1->X1_PERENG)
	
	If lPort .OR. lSpa .OR. lIngl
		RecLock("SX1",.F.)
		If lPort
			SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
		EndIf
		If lSpa
			SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
		EndIf
		If lIngl
			SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
		EndIf
		SX1->(MsUnLock())
	EndIf
Endif

RestArea( aArea )
Return