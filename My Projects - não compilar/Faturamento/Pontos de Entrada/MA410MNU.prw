#INCLUDE "PROTHEUS.CH"
#include "TOTVS.CH" 
                      
//_______________________________________________________________________________
//                                                                               | 
// Tipo de Programa: Ponto de Entrada                                            | 
// Descri��o       : Permite adicionar nova op��o de menu no M�dulo Faturamento  |
// Autor		   : Jess� Augusto	                                             |
// Data 		   : 05/09/2016                                                  |
//_______________________________________________________________________________|


User Function MA410MNU() 

	
	aAdd(aRotina,{'Reenvio de Boleto'		,"U_TECFAT02()"	 , 0 , 3,0,NIL})     
	aAdd(aRotina,{'Gerar Poder de Terceiro'	,"U_TECFAT05()"	 , 0 , 4,0,NIL})
	aAdd(aRotina,{'Amarra��o de Produtos'	,"U_TECFAT06()"	 , 0 , 4,0,NIL})
	
Return                                                           

