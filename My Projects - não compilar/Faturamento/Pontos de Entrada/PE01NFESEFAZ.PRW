#include "protheus.ch"

//=======================================================================================================================================| 
// Progama   : PE01NFESEFAZ                                                 															 |    
// Tipo      : Ponto de Entrada                                             															 | 
// Autor     : Jessé Augsuto                                                															 |
// Data      : 20/07/2016                                                   															 |
//=======================================================================================================================================|
// Descrição : Atualiza o conteúdo do parâmetro resposável pelo envio, via anexo, do Documento Fiscal no processo de Faturamento         |
//=======================================================================================================================================|
User Function PE01NFESEFAZ()

 //======================================================================================================================================|
 // Sql responsável pela consulta/atualização do conteúdo do parâmetro MV_NFEDISD  														 |
 //======================================================================================================================================|
 Local aArea     := GetArea()
 Local cWorkArea := GetNextAlias()
 Local cQuery    := ""   
 Local cMsg		 := ""
 
 Local aRetorno	 := {}
 
 cQuery := " SELECT COUNT(*) QTD						 "
 cQuery += " FROM SPED000 (NOLOCK) 						 "                     
 cQuery += " WHERE ID_ENT BETWEEN '      ' AND 'ZZZZZZ'  " 
 cQuery += " AND PARAMETRO  = 'MV_NFEDISD'				 "
 cQuery += " AND CONTEUDO   != 1 						 "
 cQuery += " AND D_E_L_E_T_ != '*' 						 " 
                                                    
 dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cWorkArea, .T., .F. )
 	                            
 //============================================================================|
 // Verifica se a quantiade de registros reornados é igual é superior a zero.  |
 //                                                                            | 
 //============================================================================|
 If (cWorkArea)->QTD > 0
       
       cQuery := " UPDATE SPED000   							"
       cQuery += " SET CONTEUDO = 1 							"  
       cQuery += " WHERE ID_ENT BETWEEN '      ' AND 'ZZZZZZ'	"
       cQuery += " AND PARAMETRO  = 'MV_NFEDISD' 				"
       cQuery += " AND CONTEUDO   != 1 							"
       cQuery += " AND D_E_L_E_T_ != '*' 						"
       
       If TCSQLExec(cQuery)  == 0
       
             Aviso("Atenção"," Falha no processo de atualização do parâmetro MV_NFEDISD. Favor verificar.",{"Ok"})
       Endif 
 Endif 
 
 (cWorkArea)->(dbCloseArea()) 
                    
 aRetorno := aClone(PARAMIXB)
                    
 RestArea(aArea)
  
Return aRetorno