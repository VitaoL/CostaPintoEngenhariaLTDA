CREATE OR REPLACE PROCEDURE VERDEMAR.CONECTO_IMPORTACAO_T(ParData  in date
				                                              ,parLoja  in number
				                                              ,ParPdv   in number
				                                              ,ParCupom in Number) AS
   vReg                           Number(14);
   vRetorno                       varchar2(100);
   vFiado                         varchar2(1);
   vContasReceber                 varchar2(1);
   vChequesReceber                varchar2(1);
   vCartaoProprio                 varchar2(1);
   vGravarTicktes                 varchar2(1);
   vTipo                          varchar2(1);
   vTotal                         number(17, 2);
   vCodigo                        number(14);
   ParCommit                      Number(7);
   vCupom                         Number(14);
   vPdv                           Number(14);
   vData                          Date;
   vCliPref                       number(14);
   vCliCheq                       number(14);
   vTotal                         number(17, 2);
   vTotalCapa                     number(17, 2);
   vTotalDetalhe                  number(17, 2);
   vTotalDetalheCpCanc            number(17, 2); -- Varivel que controla quando a capa e cancelada
   vTotalFinalizadora             number(17, 2);
   vRetornoOperador               varchar2(15);
   intCodigoLoja                   Number(15);
   vCont                          NUMBER(7);
   vContNfce                      NUMBER(7);
   vCuponsCancelados              Number(7);
   vCaixa                         Number(7);
   vCaixaAberto                   varchar2(1);
   vCNPJ                          varchar2(14);
   vAliquota                      Number(7, 2);
   vCodFinalizadora               Number(14);
   vVencimento                    Date;
   vChaveCaixa                    Number(7);
   vNomeCliente                   varchar2(50);
   vAcertaEan                     varchar2(1);
   vQtdEmb                        number(17, 3);
   vReprocesso                    varchar2(1);
   vErro                          varchar2(1000);
   strErroDetalhe                 CLOB;
   vDetalhe                       varchar(1000);
   vTipoAliq                      Varchar2(3);
   vLogImp                        Varchar2(1);
   vNumeroAutorizacao             TB_BDC_MOVI_FINALIZADORA.NUMERO_AUTORIZACAO%TYPE;
   vQtd_Parcelas_TEF              TB_BDC_MOVI_FINALIZADORA.QTD_PARCELAS_TEF%TYPE;
   vCodRoteador                   TB_BDC_MOVI_SITEF.CODIGO_REDE_AUTORIZADA_131%TYPE;
   strNSU                         TB_BDC_MOVI_SITEF.NSU_SITEF_133%TYPE;
   vInserePdv                     Number(1);
   vPulaDetalhe                   Number(1);
   vDataVenda                     Integer;
   vProcessaConjunto              Number(1);
   vRepProcessaConjunto           Number(1);
   vCupomCanceladoConjuto         Number(1);
   fltTruncar                     Number(10);
   intcontabilizavendaprincipal   produtos_compostos_tipo.contabilizavendaprincipal%Type;
   intLojaCFG                     Configuracoes.Loja%type;
   intUtilizaMPBem                loja.utilizampbem%type;
   vImportaComissao               varchar2(1);
   intComissaoPdv                 loja.comissaopdv%type;
   fltSoma                        number(15, 3);
   strMsmErroAdiciona             varchar2(100);
   vCPF_CNPJ_SocioTorcedor        socin_detalhes_cupom_desconto.cod_grp_cli%type;
   intPreVenda                    tb_bdc_detalhe_cupom.codigo_pre_venda%type;
   intPreVendaVinculo             tb_bdc_detalhe_cupom.codigo_pre_venda%type;
   intCodigoAnterior              number(15);
   strUltStatusCupom              varchar2(1);
   dtadatahorainiciallog          date;
   intstatuslogjob                number(1);
   blnDescontoFidelidadeInserido  boolean;
   vCapaTotalBruto                TB_BDC_CAPA_CUPOM.total_bruto%type;
   vDetalhesTotalBruto            tb_bdc_detalhe_cupom.total%type;
   intNovaTabelaDesconto          Number;
   intRepMaparesumo               NUMBER(7);
   intIntegracaoERP               NUMBER(1);
   vNsu_host                      TB_BDC_MOVI_SITEF.NSU_HOST_134%TYPE;
   intEcommerce                   number(1);
   intClubeVM                     number(1);
   intTerceiroPreco               number(1);

   vfinalizadorafrente            number;
   TrocaPixEcommerce              number(1);
   bkpvNumeroAutorizacao          TB_BDC_MOVI_FINALIZADORA.NUMERO_AUTORIZACAO%TYPE;
   vOSUsuario                     varchar2(100);
   intSequencia                   number;
   intContador                    number;
   fltTotalFinalizadoraEcommmerce Number(15, 2);
   fltTmpValor                    Number(15, 2);
   blnUtilizouDivergenciaEcomm    boolean;
   vCodigoConvenio                number(7);
   vCodigoEmpresa                 varchar2(14);
   intDiasProcesso                NUMBER(7);
   intContaPixDuplicado           NUMBER(7);
   intTipoCapa                    TB_BDC_CAPA_CUPOM.TIPO_CAPA%TYPE;
   dtDateVenda                    TB_BDC_CAPA_CUPOM.DATA_VENDA%TYPE;
   vNumeroLoja                    TB_BDC_CAPA_CUPOM.Numero_Loja%TYPE;
   vNumeroPDV                     TB_BDC_CAPA_CUPOM.NUMERO_PDV%TYPE;
   vNumeroCupom                   TB_BDC_CAPA_CUPOM.NUMERO_CUPOM%TYPE;
   vNUM_CRT                       TB_BDC_MOV_GFT_CRD.NUM_CRT%TYPE;
   vOPE                           TB_BDC_MOV_GFT_CRD.OPE%TYPE;
   vNSU                           TB_BDC_MOV_GFT_CRD.NSU%TYPE;
   vSIT                           TB_BDC_MOV_GFT_CRD.SIT%TYPE;
   vTIP_INT                       TB_BDC_MOV_GFT_CRD.TIP_INT%TYPE;
   ParNumAliq                     Number(15, 2);
   fltValorDoacao                 NUMBER(15, 2);
   vNumero_Cpf_Cnpj               varchar2(1000);
   fltTroco                       NUMBER(15, 2);
   intSequenciaComposto           NUMBER(7);
   intRestaurante                 NUMBER(1);
   vOrder_Id                      Number(14);
   vAuth_Code                     Varchar2(50);
   vPayless                       Number(1);
   strTelefoneClienteFidelidade   VARCHAR2(11);
   strCPFClienteFidelidade        VARCHAR2(11);
   fltAliquotaMapa1               NUMBER(15,2);
   fltAliquotaMapa2               NUMBER(15,2);
   fltAliquotaMapa3               NUMBER(15,2);
   fltAliquotaMapa4               NUMBER(15,2);
   fltAliquotaMapa5               NUMBER(15,2);
   fltAliquotaMapa6               NUMBER(15,2);
   blnFinDaWeb                    Number(1);
   vCont1                         number(10);
   intCpfCnpjConv                 NUMBER(20);
   intMercaFacil                  NUMBER(20);
   strTipoFinalizadora            VARCHAR2(2);
   strCNPJInstituicao             VARCHAR2(100);
   intFinalizadoraDoacao          NUMBER(7);
   intCodigoFinalizadora          NUMBER(7);
   intQtdeFinCupom                NUMBER(7);
   blnFinalizadoraCartaoVirtual   BOOLEAN;
   intCodigoAdministradora        NUMBER(15);
   strCodigoBandeira              VARCHAR2(15);
   fltTotalTaxas                  NUMBER(15,2);
   intStatusCumpomIntegracao     NUMBER(15); -- GABRIEL FONSECA 03/11/25 - CASO 44284
   intCartaoMesa                  NUMBER(15);
   intNsuCartaoMesa              NUMBER(15);
   intContadorEcommerce          NUMBER(2);
   intQtdeFinCupomEcommerce      NUMBER(2);
   parPedidoE                    number(19);
BEGIN
   /* GABRIEL FONSECA 10/10/2025 - CASO 44068 Ajuste na LOG_IMPORTACAO */
   PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 0;
   SELECT SYS_CONTEXT('USERENV', 'OS_USER') into vOSUsuario from DUAL;
   vCPF_CNPJ_SocioTorcedor := null;
   BEGIN
      /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                     
      PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
      PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(140, 'configuracoes');
      select CLIENTEPENDENTECHEQUES
            ,CLIENTEPENDENTEFIADO
            ,loja
            ,COMISSAOVENDEDORES
            ,NVL(MAPAALIQUOTA1,0) AS MAPAALIQUOTA1
            ,NVL(MAPAALIQUOTA2,0) AS MAPAALIQUOTA2
            ,NVL(MAPAALIQUOTA3,0) AS MAPAALIQUOTA3
            ,NVL(MAPAALIQUOTA4,0) AS MAPAALIQUOTA4
            ,NVL(MAPAALIQUOTA5,0) AS MAPAALIQUOTA5
            ,NVL(MAPAALIQUOTA6,0) AS MAPAALIQUOTA6
        into vCliCheq
            ,vCliPref
            ,intLojaCFG
            ,vImportaComissao
            ,fltAliquotaMapa1
            ,fltAliquotaMapa2
            ,fltAliquotaMapa3
            ,fltAliquotaMapa4
            ,fltAliquotaMapa5
            ,fltAliquotaMapa6
        from configuracoes;

      /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                     
      PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
      PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(168, 'configuracoes_2');
      select PRECOEMBALAGEMLOJA
            ,DIAS_PROCESSAMENTO_CUPOM
            ,RESTAURANTE
        into vAcertaEan
            ,intDiasProcesso
            ,intRestaurante
        from configuracoes_2;
      ParCommit           := 1;
      vReg                := 0;
      vTotalCapa          := 0;
      vRetornoOperador    := 0;
      vTotalDetalheCpCanc := 0;
      vCapaTotalBruto     := 0;
      vDetalhesTotalBruto := 0;
      If (ParData is Null) Then
         vDataVenda := 0;
      Else
         vDataVenda := 1;
      End If;
      --vPulaDetalhe := 0;
      -- Caso for maior que 18h, ignora os dias de venda e processa somente o dia atual
      intDiasProcesso := CASE
                            WHEN TO_CHAR(SYSDATE, 'HH24:MI') >= '18:00' THEN
                             0
                            ELSE
                             intDiasProcesso
                         END;
      -- Caso venha uma data, ignora e usa os dias para filtrar - veio atraves do ws
      IF vDataVenda = 1 THEN
         intDiasProcesso := TRUNC(SYSDATE) - ParData;
      END IF;
      /*  DELETE FROM LOG_IMPORTACAO A
      WHERE A.REPROCESSAR = 0
        AND A.CONECTO = 1
        AND A.FLAGINC <= TRUNC(SYSDATE) - 2
         OR (NOT EXISTS (SELECT 1
                           FROM EMPORIUM.EXPDET_SALE R1
                          WHERE R1.START_TIME = A.DATA
                            AND R1.STORE_KEY = A.LOJA
                            AND R1.POS_NUMBER = A.PDV
                            AND R1.TICKET_NUMBER = A.CUPOM));*/
      Commit;
      SELECT COUNT(*) INTO fltTruncar FROM EMPORIUM.EXPDET_SALE;
      If fltTruncar = 0 Then
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                     
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(215, 'EMPORIUM.EXPDET_SALE');   
         EXECUTE IMMEDIATE 'TRUNCATE TABLE EMPORIUM.EXPDET_SALE';
      End If;
      SELECT COUNT(*) INTO fltTruncar FROM EXPDET_SALE_ITEM;
      If fltTruncar = 0 Then
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                     
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(222, 'EXPDET_SALE_ITEM');
         EXECUTE IMMEDIATE 'TRUNCATE TABLE EXPDET_SALE_ITEM';
      End If;
      SELECT COUNT(*) INTO fltTruncar FROM EXPDET_SALE_MEDIA;
      If fltTruncar = 0 Then
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                     
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(229, 'EXPDET_SALE_MEDIA');
         EXECUTE IMMEDIATE 'TRUNCATE TABLE EXPDET_SALE_MEDIA';
      End If;
      -- Controle de log referente a JOB executada, feito para nao rodar em todas as execucoes
      dtadatahorainiciallog := sysdate;
      intstatuslogjob       := 0;
      /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                     
      PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
      PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(237, 'tb_bdcomum_config_exp');
      Select Count(*)
        Into intNovaTabelaDesconto
        From tb_bdcomum_config_exp
       Where id_tabela = 64
         And operacao = 1;
      intNovaTabelaDesconto := 1; -- Socin nao ser  mais utilizado e para evitar alguma troca indevida de configura  o
      BEGIN
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                     
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(247, 'LOG_IMPORTACAO/TB_FORCAR_IMPORTAR_CUPOM_CONECTO');
         SELECT COUNT(*)
           INTO intContador
           FROM LOG_IMPORTACAO                   L
               ,TB_FORCAR_IMPORTAR_CUPOM_CONECTO T
          WHERE L.CONECTO = 1
            AND L.ERROBANCO LIKE '%' || T.ERRO || '%';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            intContador := 0;
      END;
      IF intContador > 0 THEN
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                        
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(261, 'EMPORIUM.EXPDET_SALE');
         UPDATE EMPORIUM.EXPDET_SALE ES
            SET STATUS = 1
          WHERE STATUS = 3
            AND EXISTS (SELECT 1
                   FROM LOG_IMPORTACAO                   L
                       ,TB_FORCAR_IMPORTAR_CUPOM_CONECTO T
                  WHERE L.CONECTO = 1
                    AND L.ERROBANCO LIKE '%' || T.ERRO || '%'
                    AND L.DATA = TRUNC(ES.START_TIME)
                    AND L.LOJA = ES.STORE_KEY
                    AND L.PDV = ES.POS_NUMBER
                    AND L.CUPOM = ES.TICKET_NUMBER);
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                        
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(277, 'EMPORIUM.LOG_IMPORTACAO');
         DELETE FROM LOG_IMPORTACAO ES
          WHERE EXISTS (SELECT 1
                   FROM LOG_IMPORTACAO                   L
                       ,TB_FORCAR_IMPORTAR_CUPOM_CONECTO T
                  WHERE L.CONECTO = 1
                    AND L.ERROBANCO LIKE '%' || T.ERRO || '%'
                    AND L.DATA = ES.DATA
                    AND L.LOJA = ES.LOJA
                    AND L.PDV = ES.PDV
                    AND L.CUPOM = ES.CUPOM);
         COMMIT;
      END IF;
      /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                        
      PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
      PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(292, 'VI_LOJA_VENDAS');
      FOR c_LOJ IN (SELECT *
                      FROM VI_LOJA_VENDAS
                     WHERE ParLoja = -1
                       AND ((NUMEROLOJA <= 4) OR (NUMEROLOJA BETWEEN 100 AND 104))
                       AND RESTAURANTE = intRestaurante
                    UNION
                    SELECT *
                      FROM VI_LOJA_VENDAS
                     WHERE ParLoja = -2
                       AND ((NUMEROLOJA BETWEEN 5 AND 8) OR (NUMEROLOJA BETWEEN 105 AND 108))
                       AND RESTAURANTE = intRestaurante
                    UNION
                    SELECT *
                      FROM VI_LOJA_VENDAS
                     WHERE ParLoja = -3
                       AND ((NUMEROLOJA BETWEEN 9 AND 12) OR (NUMEROLOJA BETWEEN 109 AND 112))
                       AND RESTAURANTE = intRestaurante
                    UNION
                    SELECT *
                      FROM VI_LOJA_VENDAS
                     WHERE ParLoja = -4
                       AND ( (NUMEROLOJA >= 13 and NUMEROLOJA < 100)  OR NUMEROLOJA >= 113)
                       AND RESTAURANTE = intRestaurante
                    UNION
                    SELECT *
                      FROM VI_LOJA_VENDAS
                     WHERE NUMEROLOJA = ParLoja
                       AND RESTAURANTE = intRestaurante
                    UNION
                    SELECT *
                      FROM VI_LOJA_VENDAS
                     WHERE RESTAURANTE = intRestaurante
                       AND ParLoja = 0)
      LOOP
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                        
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(329, 'EMPORIUM.EXPDET_SALE');
         For r1 in (SELECT TRUNC(ES.FISCAL_DATE) AS DATA_VENDA
                          ,ES.STORE_KEY AS NUMERO_LOJA
                          ,ES.POS_NUMBER AS NUMERO_PDV
                          ,ES.TICKET_NUMBER AS NUMERO_CUPOM
                          ,ES.START_TIME AS HORA_VENDA
                          ,CASE
                              WHEN (ES.VOIDED = 1 OR ES.SALE_TYPE = 32) THEN
                               2 --CANCELADO
                              WHEN (ES.SALE_TYPE = 65 OR ES.STATUS = 1) AND ES.VOIDED = 0 THEN
                               7 --NORMAL
                           END AS SITUACAO_CAPA
                          ,ES.SALE_TYPE
                          ,ES.VOIDED
                          ,ES.AMOUNT_DUE AS TOTAL_LIQUIDO
                          ,ES.AMOUNT_DUE + ES.DISCOUNT AS TOTAL_BRUTO
                          ,0 AS TOTAL_DESCONTO
                          ,ES.DISCOUNT AS TOTAL_DESCONTO_ITEM
                          ,ES.INCREASE AS TOTAL_ACRESCIMO
                          ,CASE
                              WHEN (ES.VOIDED = 1) THEN
                               ES.AMOUNT_DUE
                              ELSE
                               0
                           END AS TOTAL_CANCELADO
                          ,ES.INTEREST AS TOTAL_JUROS
                          ,ES.CASHIER_ID AS CODIGO_OPERADOR
                          ,ES.AUTHORIZER_ID AS USUARIO_CANCELOU
                          ,NVL((SELECT AD.DATA_VALUE
                                 FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                                WHERE AD.DATA_ID = 71
                                  AND AD.STORE_KEY = ES.STORE_KEY
                                  AND AD.POS_NUMBER = ES.POS_NUMBER
                                  AND TRUNC(AD.START_TIME) = TRUNC(ES.START_TIME)
                                  AND AD.TICKET_NUMBER = ES.TICKET_NUMBER
                                  AND ROWNUM <= 1), 0) AS MOTIVO_CANCELAMENTO
                          ,REPLACE((SELECT AD.DATA_VALUE
                                     FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                                    WHERE AD.DATA_ID = 104
                                      AND AD.STORE_KEY = ES.STORE_KEY
                                      AND AD.POS_NUMBER = ES.POS_NUMBER
                                      AND AD.TICKET_NUMBER = ES.TICKET_NUMBER
                                      AND TRUNC(AD.START_TIME) = TRUNC(ES.START_TIME)
                                      AND ROWNUM <= 1), '*********', '******') AS NUMERO_CARTAO
                          ,(SELECT AD.DATA_VALUE
                              FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                             WHERE AD.DATA_ID = 491
                               AND AD.STORE_KEY = ES.STORE_KEY
                               AND TRUNC(AD.START_TIME) = TRUNC(ES.START_TIME)
                               AND AD.POS_NUMBER = ES.POS_NUMBER
                               AND AD.TICKET_NUMBER = ES.TICKET_NUMBER
                               AND ROWNUM <= 1) AS NUMERO_CPF_CNPJ
                          ,(SELECT ES_M.DATA_VALUE
                              FROM EMPORIUM.EXPDET_ANSWER_DATA ES_M
                             WHERE ES_M.STORE_KEY = ES.STORE_KEY
                               AND ES_M.POS_NUMBER = ES.POS_NUMBER
                               AND ES_M.TICKET_NUMBER = ES.TICKET_NUMBER
                               AND ES_M.DATA_ID = 482
                               AND TRUNC(ES_M.START_TIME) = TRUNC(ES.START_TIME)
                               AND ROWNUM = 1) AS CODIGO_CONVENIO
                          ,(SELECT ES_AD.DATA_VALUE
                              FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                             WHERE ES_AD.STORE_KEY = ES.STORE_KEY
                               AND ES_AD.POS_NUMBER = ES.POS_NUMBER
                               AND ES_AD.TICKET_NUMBER = ES.TICKET_NUMBER
                               AND ES_AD.DATA_ID = 483
                               AND TRUNC(ES_AD.START_TIME) = TRUNC(ES.START_TIME)
                               AND ROWNUM = 1) AS CODIGO_CONVENIADO
                          ,(SELECT AD.DATA_VALUE
                              FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                             WHERE AD.DATA_ID = 1
                               AND AD.STORE_KEY = ES.STORE_KEY
                               AND TRUNC(AD.START_TIME) = TRUNC(ES.START_TIME)
                               AND AD.POS_NUMBER = ES.POS_NUMBER
                               AND AD.TICKET_NUMBER = ES.TICKET_NUMBER
                               AND ROWNUM <= 1) AS CODIGO_CLIENTE
                          ,SALE_TYPE AS TIPO_CAPA
                          ,SALE_TYPE AS TIPO_RECEBIMENTO
                          ,
                           --(SELECT PE.CODIGO FROM PESSOAS PE WHERE PE.CPF = ES.CUSTOMER_ID) AS CODIGO_CLIENTE,
                           ES.TYPE_PRICE AS FORMA_RECEBIMENTO
                          ,NULL AS ALGORITIMO
                          ,NULL AS DATA_VENCIMENTO
                          ,0 AS VALOR_MINIMO
                          ,ES.AMOUNT_DUE AS VALOR_TOTAL_FATURA
                          ,0 AS VALOR_MULTA
                          ,0 AS VALOR_ENCARGO
                          ,NULL AS DIAS_ATRASO
                          ,NULL AS NUMERO_RECIBO
                          ,NULL AS TIPO_REGISTRO
                          ,NULL AS NUMERO_CONTRATO
                          ,NULL AS PARCELA
                          ,NULL AS VALOR_IOF
                          ,NULL AS STRING_RETORNO
                          ,NULL AS VALOR_DESCONTO_SACOLA
                          ,ES.PROCESS_TIME AS DATA_HORA_FIM_VENDA
                          ,0 AS MELIUZ
                          ,(SELECT AD.DATA_VALUE
                              FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                             WHERE AD.DATA_ID = 389
                               AND AD.STORE_KEY = ES.STORE_KEY
                               AND TRUNC(AD.START_TIME) = TRUNC(ES.START_TIME)
                               AND AD.POS_NUMBER = ES.POS_NUMBER
                               AND AD.TICKET_NUMBER = ES.TICKET_NUMBER
                               AND ROWNUM <= 1) AS SELOS_DESCARTADOS
                          ,(SELECT AD.DATA_VALUE
                              FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                             WHERE AD.DATA_ID = 381
                               AND AD.STORE_KEY = ES.STORE_KEY
                               AND TRUNC(AD.START_TIME) = TRUNC(ES.START_TIME)
                               AND AD.POS_NUMBER = ES.POS_NUMBER
                               AND AD.TICKET_NUMBER = ES.TICKET_NUMBER
                               AND ROWNUM <= 1) AS SELOS_RESGATADOS,
                               ES.STATUS -- GABRIEL FONSECA - 03/11/25 CASO 44284 
                      FROM EMPORIUM.EXPDET_SALE ES
                     WHERE ES.SALE_TYPE IN (65, 32, 127)
                     AND 1=1
                       AND ES.STATUS in (1, -3, 98) -- GABRIEL FONSECA 03/11/25 - INCLUSÃO DO STATUS 98 PARA CUPONS "CARTÃO MESA COM NSU NULO"
                       AND ((TRUNC(ES.START_TIME) >= TRUNC(TO_DATE(PARDATA)) AND TRUNC(ES.START_TIME) < TRUNC(TO_DATE(PARDATA) + 1)) OR (NVL(vDataVenda, 0) = 0))
                       AND ((ES.POS_NUMBER = NVL(PARPDV, 0)) OR (NVL(PARPDV, 0) = 0))
                       AND ((ES.TICKET_NUMBER = NVL(PARCUPOM, 0)) OR (NVL(PARCUPOM, 0) = 0))
                       AND (ES.STORE_KEY = c_LOJ.NUMEROLOJA)
                           -- AND ES.TICKET_NUMBER <> 135751
                       AND ((TRUNC(ES.START_TIME) BETWEEN TRUNC(SYSDATE) - intDiasProcesso AND TRUNC(SYSDATE)) or
                           --AND ( (TRUNC(ES.START_TIME) BETWEEN TRUNC(SYSDATE) - 5 AND TRUNC(SYSDATE) ) or
                           ((vOSUsuario in ('danilo.bruneli')) and TRUNC(ES.START_TIME) = TRUNC(TO_DATE(PARDATA)))) --PROVISÓRIO SÓ PARA CONECTO
                       AND ROWNUM <= c_LOJ.QTDE_PROCESSA_CUPOM
                          --AND ((TRUNC(ES.START_TIME) >= TRUNC(SYSDATE) - 90) AND ROWNUM <= 3000 or (vOSUsuario in ('danilo.bruneli', 'dbrun', 'agnaldo.mari', 'talita.salles', 'daniel.senra', 'tadeu.machado')))
                        OR (EXISTS (SELECT 1
                                      FROM REPROCESSO_VENDA R
                                     WHERE R.DATA = TRUNC(ES.START_TIME)
                                       AND R.LOJA = ES.STORE_KEY
                                       AND R.PDV = ES.POS_NUMBER
                                       AND R.CUPOM = ES.TICKET_NUMBER
                                       AND R.STATUS = 0)) --PROVISÓRIO CAIO - 20/09/2023
                    --ORDER BY DATA_VENDA DESC
                     ORDER BY DATA_VENDA DESC)
         LOOP
            /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
            PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;
            PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(468, 'EXPDET_SALE_REP');
            insert into EXPDET_SALE_REP
              (data_venda, numero_loja, numero_pdv, numero_cupom, flag_inc, local)
            values
              (r1.data_venda, r1.numero_loja, r1.numero_pdv, r1.numero_cupom, sysdate,0);

            /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                      
            PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
            PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(476, 'REPROCESSO_VENDA');
            UPDATE REPROCESSO_VENDA R
               SET STATUS = 1
             WHERE R.DATA = R1.DATA_VENDA
               AND R.LOJA = R1.NUMERO_LOJA
               AND R.PDV = R1.NUMERO_PDV
               AND R.CUPOM = R1.NUMERO_CUPOM
               AND R.STATUS = 0;
            intstatuslogjob               := 1;
            intPreVenda                   := 0;
            vProcessaConjunto             := 0;
            vRepProcessaConjunto          := 0;
            vLogImp                       := 'N';
            vNumero_Cpf_Cnpj              := '';
            vDetalhe                      := 'Data: ' || r1.data_venda || ' - Loja: ' || R1.NUMERO_LOJA || ' - PDV: ' || r1.numero_pdv || ' - Cupom: ' || r1.numero_cupom;
            vReg                          := vReg + 1;
            vReprocesso                   := 'N';
            vErro                         := null;
            blnDescontoFidelidadeInserido := false;
            intTipoCapa                   := r1.TIPO_CAPA;
            dtDateVenda                   := r1.DATA_VENDA;
            vNumeroLoja                   := r1.NUMERO_LOJA;
            vNumeroPDV                    := r1.NUMERO_PDV;
            vNumeroCupom                  := r1.Numero_Cupom;
            Begin
               Begin
                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                      
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(504, 'loja/lojas_pdv');
                  select l.codigo
                        ,1
                        ,l.utilizampbem
                        ,l.comissaopdv
                    into intCodigoLoja
                        ,vInserePdv
                        ,intUtilizaMPBem
                        ,intcomissaopdv
                    from loja      l
                        ,lojas_pdv lp
                   where l.codigo = lp.loja
                     and l.numeroloja = r1.numero_loja
                     and lp.pdv = r1.numero_pdv;
               Exception
                  when no_data_found Then
                     Begin
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(523, 'loja/lojas_pdv');
                        select codigo
                              ,1
                              ,UtilizaMPBem
                              ,l.comissaopdv
                          into intCodigoLoja
                              ,vInserePdv
                              ,intUtilizaMPBem
                              ,intcomissaopdv
                          from loja      l
                              ,lojas_pdv lp
                         where l.codigo = lp.loja
                           and lp.pdv = r1.numero_pdv
                           and lp.lojaimportacao = (select lj.codigo
                                                      from loja lj
                                                     where lj.codigo = lp.lojaimportacao
                                                       and lj.numeroloja = r1.numero_loja);
                     Exception
                        when no_data_found Then
                           intCodigoLoja    := r1.numero_loja;
                           vInserePdv      := 0;
                           intUtilizaMPBem := 0;
                     End;
               End;
               if NVL(r1.SALE_TYPE, 0) = 127 and 1 = 1 Then
                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(550, 'PRC_CONECTO_CARTAO_PRESENTE');
                  PRC_CONECTO_CARTAO_PRESENTE(ParData => dtDateVenda, ParLoja => vNumeroLoja, ParPDV => vNumeroPDV, ParCupom => vNumeroCupom, ParOperacao => VITRUVIO.FNC_CONFIG('operacao_cartao_presente'), ParTipoCapa => r1.tipo_capa);
                  vInserePDV := 0;
                  --vPulaDetalhe := 1;
                  --Atualiza status para processado - Henrique - 15/12/2023
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(558, 'EMPORIUM.EXPDET_SALE');
                     UPDATE EMPORIUM.EXPDET_SALE ES
                        SET ES.STATUS = 2
                      WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                        AND ES.STORE_KEY = R1.NUMERO_LOJA
                        AND ES.POS_NUMBER = R1.NUMERO_PDV
                        AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(568, 'LOG_IMPORTACAO');
                     DELETE FROM LOG_IMPORTACAO
                      WHERE DATA = R1.DATA_VENDA
                        AND LOJA = R1.NUMERO_LOJA
                        AND PDV = R1.NUMERO_PDV
                        AND CUPOM = R1.NUMERO_CUPOM
                        AND CONECTO = 1;
               end If;

               -- GABRIEL FONSECA 03/11/2025 -  CASO 44284 - SCRIPT PARA APENAS ATUALIZAR O NSU EM CASO DE REPROCESSAMENTO DE CUPOM "CARTÃO MESA COM NSU NULO"
               -- SE STATUS FOR 98 ATUALIZAR O NSU;
               if R1.STATUS = 98 Then
                  vInserePDV := 0;

                  FOR R22 IN (SELECT SF.*
                                FROM SOCIN_FINALIZADORAS SF
                               WHERE SF.LOJA = intCodigoLoja
                                 AND SF.PDV = R1.NUMERO_PDV
                                 AND SF.CUPOM = R1.NUMERO_CUPOM
                                 AND SF.DATA = R1.DATA_VENDA
                                 AND SF.FINALIZADORA = 9)
                  LOOP
                     BEGIN
                         SELECT ES_MD.DATA_VALUE
                           INTO intNsuCartaoMesa
                           FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA ES_MD
                          WHERE ES_MD.STORE_KEY = R1.NUMERO_LOJA
                            AND ES_MD.POS_NUMBER = R22.PDV
                            AND ES_MD.TICKET_NUMBER = R22.CUPOM
                            AND TRUNC(ES_MD.START_TIME) = TRUNC(R22.DATA)
                            AND ES_MD.DATA_ID = 204
                            AND ES_MD.SEQUENCE = R22.SEQUENCIA -1;
                     EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                               intNsuCartaoMesa := NULL;
                     END;

                     IF intNsuCartaoMesa IS NOT NULL THEN

                        UPDATE SOCIN_FINALIZADORAS
                           SET NSU_HOST_134 = intNsuCartaoMesa
                              ,BLINDAR      = 1
                         WHERE CHAVE = R22.CHAVE;
                  END IF;
                  END LOOP;

                  UPDATE EMPORIUM.EXPDET_SALE ES
                     SET ES.STATUS = 2
                   WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                     AND ES.STORE_KEY = R1.NUMERO_LOJA
                     AND ES.POS_NUMBER = R1.NUMERO_PDV
                     AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;

                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(568, 'LOG_IMPORTACAO');
                  DELETE FROM LOG_IMPORTACAO
                   WHERE DATA = R1.DATA_VENDA
                     AND LOJA = R1.NUMERO_LOJA
                     AND PDV = R1.NUMERO_PDV
                     AND CUPOM = R1.NUMERO_CUPOM
                     AND CONECTO = 1;
               END IF;
               If vInserePdv = 1 Then
                  --Caso 36993 - Caio Guelre - 13/06/2024
                  BEGIN
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(582, 'PDV_FECHAMENTO');
                     SELECT COUNT(*)
                       INTO intContador
                       FROM PDV_FECHAMENTO P
                      WHERE P.DATA = R1.DATA_VENDA
                        AND P.LOJA = intCodigoLoja
                        AND P.PDV = R1.NUMERO_PDV
                        AND P.STATUS = 'S';
                  EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                           intContador := 0;
                  END;
                  IF intContador > 0 THEN
                     PRC_RAISEAPPLICATION('A tesouraria já foi fechada para a data '||TO_CHAR(R1.DATA_VENDA, 'DD/MM/RRRR')||', loja '||R1.NUMERO_LOJA||' e pdv '||R1.NUMERO_PDV||'. Importação de cupom não permitida!' || ' Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                  END IF;

                  -- CODIGO MONTADO PARA DELETAR CASO EXISTE O MESMO CUPOM COM SITUACOES DIFERENTES
                  intIntegracaoERP := 1;
                  BEGIN
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(603, 'SOCIN_CAPA_CUPOM');
                     SELECT S.CUPOM
                           ,S.SITUACAO
                           ,S.INTEGRACAO_ERP
                       INTO vCont
                           ,strUltStatusCupom
                           ,intIntegracaoERP
                       FROM SOCIN_CAPA_CUPOM S
                      WHERE DATA = R1.DATA_VENDA
                        AND LOJA = intCodigoLoja
                        AND PDV = R1.NUMERO_PDV
                        AND CUPOM = R1.NUMERO_CUPOM;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        vCont            := 0;
                        intIntegracaoERP := 1;
                  END;
                  IF vCont > 0 THEN
                     For r10 in (SELECT DISTINCT LOJA
                                                ,DATA
                                                ,PDV
                                                ,CUPOM
                                                ,PRODUTOPRINCIPAL
                                                ,SEQUENCIACOMPOSTO
                                                ,QUANTIDADE
                                                ,SITUACAO
                                   FROM PRODUTOS_MOVIMENTO_COMPOSTOS
                                  WHERE LOJA = intCodigoLoja
                                    AND DATA = r1.data_venda
                                    AND PDV = r1.numero_pdv
                                    AND CUPOM = r1.numero_cupom
                                  order by SEQUENCIACOMPOSTO)
                     loop
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(636, 'PRODUTOS_MOVIMENTO_COMPOSTOS');
                        if r10.situacao = 'C' then
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(642, 'PRC_ESTOQUE_COMP_PRINCIPAL');
                           PRC_ESTOQUE_COMP_PRINCIPAL(r10.loja, r10.pdv, r10.cupom, r10.sequenciacomposto, r10.produtoprincipal, r10.quantidade, r10.data, 'C', 'N');
                           PRC_ESTOQUE_COMP_PRINCIPAL(r10.loja, r10.pdv, r10.cupom, r10.sequenciacomposto, r10.produtoprincipal, r10.quantidade, r10.data, 'D', 'S');
                        end if;
                        if r10.situacao = 'P' then
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(649, 'PRC_ESTOQUE_COMP_PRINCIPAL');
                           PRC_ESTOQUE_COMP_PRINCIPAL(r10.loja, r10.pdv, r10.cupom, r10.sequenciacomposto, r10.produtoprincipal, r10.quantidade, r10.data, 'C', 'N');
                        end if;
                     End Loop;
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(655, 'SOCIN_CAPA_CUPOM');
                     DELETE FROM SOCIN_CAPA_CUPOM
                      WHERE DATA = R1.DATA_VENDA
                        AND LOJA = intCodigoLoja
                        AND PDV = R1.NUMERO_PDV
                        AND CUPOM = R1.NUMERO_CUPOM;
                     vReprocesso := 'S';
                     -- Processamento do composto principal
                     -- que foi explidido na venda por PDV para fazer controle de venda
                     -- e de estoque, no reprocesso retira-lo do estoque
                     vRepProcessaConjunto := 1;
                     -- SE O CUPOM ANTERIOR ERA NORMAL E JA INTEGROU, ENVIO NOVAMENTE
                     IF strUltStatusCupom = 'P' AND intIntegracaoERP = 0 THEN
                        -- SE JA FOI INTEGRADO, ENVIO NOVAMENTE
                        intIntegracaoERP := 2; -- MARCO PARA INTEGRAR
                     ELSIF R1.SITUACAO_CAPA IN (2, 9) AND intIntegracaoERP IN (1, 4) THEN
                        -- SE E CANCELADO DIRETO E N?O INTEGROU O CUPOM NORMAL, N?O VAMOS ENVIAR
                        intIntegracaoERP := 5; --MARCO PARA N O INTEGRAR
                     ELSIF intIntegracaoERP = 0 THEN
                        -- SE JA FOI INTEGRADO, ENVIO NOVAMENTE
                        intIntegracaoERP := 2; -- MARCO PARA ENVIAR PARA INTEGRAR
                     END IF;
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(679, 'COMISSOES');
                     DELETE FROM COMISSOES C
                      WHERE c.emissao = R1.DATA_VENDA
                        AND LOJA = intCodigoLoja
                        AND PDV = R1.NUMERO_PDV
                        AND CUPOM = R1.NUMERO_CUPOM;

                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(690, 'PRC_VENDA_DOACAO_CARTAO_PIX');
                     --Caso 43573 - Caio - 24/04/2025
                     PRC_VENDA_DOACAO_CARTAO_PIX(ParTipo         => 'C'
                                                ,ParData         => R1.DATA_VENDA
                                                ,ParLoja         => intCodigoLoja
                                                ,ParNumeroLoja   => R1.NUMERO_LOJA
                                                ,ParPDV          => R1.NUMERO_PDV
                                                ,ParCupom        => R1.NUMERO_CUPOM
                                                ,ParSequencia    => 0
                                                ,ParFinalizadora => 0
                                                ,ParValor        => 0);
                  ELSE
                     IF R1.SITUACAO_CAPA IN (2, 9) THEN
                        -- SE E CANCELADO DIRETO, N O VAMOS ENVIAR
                        intIntegracaoERP := 5; --MARCO PARA NAO INTEGRAR
                     END IF;
                  END IF;
                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(690, 'LOG_IMPORTACAO');
                  DELETE FROM LOG_IMPORTACAO
                   WHERE DATA = R1.DATA_VENDA
                     AND LOJA = r1.Numero_loja
                     AND PDV = R1.NUMERO_PDV
                     AND CUPOM = R1.NUMERO_CUPOM
                     AND CONECTO = 1;
                  -- CODIGO MONTADO PARA DELETAR CASO EXISTE O MESMO CUPOM COM SITUACOES DIFERENTES
                  -- Ver qual era o r1.tipo_recebimento = 20
                  vCapaTotalBruto     := 0;
                  vDetalhesTotalBruto := 0;
                  If not (R1.SITUACAO_CAPA IN (2, 9) and (r1.tipo_recebimento = 20)) Then
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                     
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(722, 'SOCIN_CAPA_CUPOM_GRAVA');
                     SOCIN_CAPA_CUPOM_GRAVA(r1.numero_pdv, r1.numero_cupom, r1.hora_venda, r1.total_liquido, 0, --Sequencia Ini
                                            0, --Sequencia Fim
                                            r1.codigo_operador, r1.Total_Bruto, 0, --AnuladoVenda
                                            r1.total_desconto, r1.total_desconto_item, 0, --Anula desconto no item
                                            r1.total_acrescimo, 0, --Acrescimo no item
                                            0, --Vale
                                            case
                                                when length(r1.codigo_convenio) > 6 then
                                                 0
                                                else
                                                 r1.codigo_convenio
                                             end, r1.codigo_cliente, r1.codigo_conveniado, 0, --Limite,
                                            0, --Saldo
                                            0, --Bonus
                                            r1.total_juros, r1.motivo_cancelamento, '', -- Codigo Adicional
                                            '', -- Situacao Tef
                                            '', -- Codigo 20
                                            '', -- Entrega
                                            case
                                                when (R1.SITUACAO_CAPA IN (2, 9)) then
                                                 'C'
                                                else
                                                 'P'
                                             end, 0, -- Desconto Far
                                            '', -- Flag Far
                                            replace(r1.numero_cartao, '*******', '******'), --Flag Via Brasil
                                            0, -- Pontuacao
                                            intCodigoLoja, r1.data_venda, r1.total_liquido, --ParValor
                                            0, -- Anula desconto
                                            vReprocesso, --Indica se e reprocesso
                                            0, -- Tipo Fidelidade
                                            r1.usuario_cancelou, --Usuario que cancelou
                                            0, --Servico
                                            r1.Valor_Desconto_Sacola, r1.DATA_HORA_FIM_VENDA, intIntegracaoERP, R1.SELOS_RESGATADOS, R1.SELOS_DESCARTADOS, vRetorno); --Retorno
                     vCapaTotalBruto := r1.total_bruto;
                     If R1.SITUACAO_CAPA IN (2, 9) Then
                        vTotalCapa := vTotalCapa;
                     Else
                        vTotalCapa := r1.total_liquido;
                     End If;
                     --End If;
                     --If vInserePdv = 1 And vPulaDetalhe = 0 Then
                     Begin
                        vTotalDetalhe       := 0;
                        vTotalDetalheCpCanc := 0;
                        vDetalhesTotalBruto := 0;
                        intPreVenda         := 0;
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                             
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(773, 'EMPORIUM.EXPDET_SALE_ITEM');
                        For r2 in (SELECT TRUNC(ES_D.START_TIME) AS DATA_VENDA
                                         ,ES_D.STORE_KEY AS NUMERO_LOJA
                                         ,ES_D.POS_NUMBER AS NUMERO_PDV
                                         ,ES_D.TICKET_NUMBER AS NUMERO_CUPOM
                                         ,(ES_D.SEQUENCE + 1) AS SEQUENCIA
                                         ,CASE
                                             WHEN ES_D.VOIDED = 1 THEN
                                              2
                                             ELSE
                                              1
                                          END AS SITUACAO_DETALHE
                                         ,ES_D.SKU_ID AS CODIGO_EAN
                                         ,ES_D.PLU_ID AS CODIGO_PRODUTO
                                         ,ES_D.DESC_PLU AS DESCRICAO
                                         ,ES_D.QUANTITY AS QUANTIDADE
                                         ,ES_D.UNIT_PRICE AS PRECO
                                         ,ES_D.DISCOUNT AS DESCONTO
                                         ,ES_D.AMOUNT AS TOTAL
                                         ,ES_D.INCREASE AS ACRESCIMO
                                         ,NVL(ES_D.TYPE_PRICE,1) AS TYPE_PRICE
                                         ,0 /*ES_D.INCREASE - 25/01/2024 - 34466 - Vinícius */ AS AJUSTE_POSITIVO
                                         ,0 AS AJUSTE_NEGATIVO
                                         ,NVL(ES_D.CLERK_ID, 0) AS VENDEDOR
                                         ,ES_D.VOIDED AS USUARIO_CANCELOU
                                         ,NVL((SELECT AD.DATA_VALUE
                                                FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                                               WHERE AD.DATA_ID = 71
                                                 AND AD.STORE_KEY = ES_D.STORE_KEY
                                                 AND AD.POS_NUMBER = ES_D.POS_NUMBER
                                                 AND AD.TICKET_NUMBER = ES_D.TICKET_NUMBER
                                                 AND trunc(AD.START_TIME) = trunc(ES_D.START_TIME)
                                                 AND ROWNUM <= 1
                                                 AND ES_D.SEQUENCE = AD.ITEM_SEQUENCE), 0) AS MOTIVO_CANCELAMENTO
                                         ,(SELECT 1
                                             FROM EMPORIUM.EXPDET_SALE ES
                                            WHERE ES.SALE_TYPE = 127
                                              AND ES.STORE_KEY = ES_D.STORE_KEY
                                              AND ES.POS_NUMBER = ES_D.POS_NUMBER
                                              AND ES.TICKET_NUMBER = ES_D.TICKET_NUMBER
                                              AND trunc(ES.START_TIME) = trunc(ES_D.START_TIME)
                                              AND ROWNUM <= 1) AS CARTAO_PRESENTE
                                         ,NVL((SELECT 1
                                                FROM EMPORIUM.EXPDET_SALE_MEDIA ES_M
                                               WHERE ES_M.STORE_KEY = ES_D.STORE_KEY
                                                 AND ES_M.POS_NUMBER = ES_D.POS_NUMBER
                                                 AND ES_M.TICKET_NUMBER = ES_D.TICKET_NUMBER
                                                 AND ES_M.MEDIA_ID = 15
                                                 AND trunc(ES_M.START_TIME) = trunc(ES_D.START_TIME)
                                                 AND ES_M.SEQUENCE = ES_D.SEQUENCE
                                                 AND ROWNUM <= 1), 0) AS TIPO_DESCONTO
                                         ,(SELECT AD.DATA_VALUE
                                             FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                                            WHERE AD.DATA_ID = 71
                                              AND AD.STORE_KEY = ES_D.STORE_KEY
                                              AND AD.POS_NUMBER = ES_D.POS_NUMBER
                                              AND AD.TICKET_NUMBER = ES_D.TICKET_NUMBER
                                              AND trunc(AD.START_TIME) = trunc(ES_D.START_TIME)
                                              AND ROWNUM <= 1
                                              AND ES_D.SEQUENCE = AD.ITEM_SEQUENCE) AS MOTIVO_DESCONTO
                                         ,TRIM(ES_D.POS_ID) AS CODIGO_NATUREZA
                                         ,(SELECT IK.TYPE_PRICE
                                             FROM ((SELECT SI.TYPE_PRICE
                                                          ,AD.ITEM_SEQUENCE AS FAIXA_INICIAL
                                                          ,(SELECT AD196.ITEM_SEQUENCE
                                                              FROM EMPORIUM.SALE S196
                                                             INNER JOIN EMPORIUM.SALE_ITEM SI196
                                                                ON SI196.STORE_KEY = S196.STORE_KEY
                                                               AND SI196.POS_NUMBER = S196.POS_NUMBER
                                                               AND SI196.TICKET_NUMBER = S196.TICKET_NUMBER
                                                               AND SI196.START_TIME = S196.START_TIME
                                                             INNER JOIN EMPORIUM.ANSWER_DATA AD196
                                                                ON AD196.STORE_KEY = S196.STORE_KEY
                                                               AND AD196.POS_NUMBER = S196.POS_NUMBER
                                                               AND AD196.TICKET_NUMBER = S196.TICKET_NUMBER
                                                               AND AD196.START_TIME = S196.START_TIME
                                                               AND AD196.ITEM_SEQUENCE = SI196.SEQUENCE
                                                             WHERE S196.STORE_KEY = S.STORE_KEY
                                                               AND S196.POS_NUMBER = S.POS_NUMBER
                                                               AND S196.TICKET_NUMBER = S.TICKET_NUMBER
                                                               AND TRUNC(S196.START_TIME) = TRUNC(S.START_TIME)
                                                               AND TRUNC(S196.FISCAL_DATE) = TRUNC(S.START_TIME)
                                                               AND AD196.SEQUENCE = AD.SEQUENCE + 1
                                                               AND AD196.DATA_ID IN (196)) FAIXA_FINAL
                                                          ,TRUNC(S.START_TIME)
                                                          ,S.STORE_KEY
                                                          ,S.POS_NUMBER
                                                          ,S.TICKET_NUMBER
                                                          ,(SELECT ES_DV.DATA_VALUE
                                                              FROM EMPORIUM.ANSWER_DATA ES_DV
                                                             WHERE TRUNC(ES_DV.START_TIME) = TRUNC(S.START_TIME)
                                                               AND ES_DV.STORE_KEY = S.STORE_KEY
                                                               AND ES_DV.POS_NUMBER = S.POS_NUMBER
                                                               AND ES_DV.TICKET_NUMBER = S.TICKET_NUMBER
                                                               AND ES_DV.DATA_ID = 194
                                                               AND ES_DV.ITEM_SEQUENCE = AD.ITEM_SEQUENCE) AS QTDE_KIT
                                                      FROM EMPORIUM.SALE        S
                                                          ,EMPORIUM.SALE_ITEM   SI
                                                          ,EMPORIUM.ANSWER_DATA AD
                                                     WHERE SI.STORE_KEY = S.STORE_KEY
                                                       AND SI.POS_NUMBER = S.POS_NUMBER
                                                       AND SI.TICKET_NUMBER = S.TICKET_NUMBER
                                                       AND SI.START_TIME = S.START_TIME
                                                       AND AD.STORE_KEY = S.STORE_KEY
                                                       AND AD.POS_NUMBER = S.POS_NUMBER
                                                       AND AD.TICKET_NUMBER = S.TICKET_NUMBER
                                                       AND AD.START_TIME = S.START_TIME
                                                       AND AD.ITEM_SEQUENCE = SI.SEQUENCE
                                                       AND AD.DATA_ID IN (195)
                                                       AND TRUNC(S.START_TIME) = TRUNC(ES_D.START_TIME) --'18-DEC-2023'
                                                       AND S.STORE_KEY = ES_D.STORE_KEY --2
                                                       AND S.POS_NUMBER = ES_D.POS_NUMBER --168
                                                       AND S.TICKET_NUMBER = ES_D.TICKET_NUMBER)) IK
                                            WHERE ES_D.SEQUENCE >= IK.FAIXA_INICIAL
                                              AND ES_D.SEQUENCE <= IK.FAIXA_FINAL
                                              AND ES_D.TYPE_PRICE = IK.TYPE_PRICE
                                              AND ES_D.TYPE_PRICE > 1) AS CODIGO_CONJUNTO_PRODUTO -- 26054
                                         ,(SELECT CAST(IK.QTDE_KIT AS NUMBER(15, 3))
                                             FROM ((SELECT SI.TYPE_PRICE
                                                          ,AD.ITEM_SEQUENCE AS FAIXA_INICIAL
                                                          ,(SELECT AD196.ITEM_SEQUENCE
                                                              FROM EMPORIUM.SALE S196
                                                             INNER JOIN EMPORIUM.SALE_ITEM SI196
                                                                ON SI196.STORE_KEY = S196.STORE_KEY
                                                               AND SI196.POS_NUMBER = S196.POS_NUMBER
                                                               AND SI196.TICKET_NUMBER = S196.TICKET_NUMBER
                                                               AND SI196.START_TIME = S196.START_TIME
                                                             INNER JOIN EMPORIUM.ANSWER_DATA AD196
                                                                ON AD196.STORE_KEY = S196.STORE_KEY
                                                               AND AD196.POS_NUMBER = S196.POS_NUMBER
                                                               AND AD196.TICKET_NUMBER = S196.TICKET_NUMBER
                                                               AND AD196.START_TIME = S196.START_TIME
                                                               AND AD196.ITEM_SEQUENCE = SI196.SEQUENCE
                                                             WHERE S196.STORE_KEY = S.STORE_KEY
                                                               AND S196.POS_NUMBER = S.POS_NUMBER
                                                               AND S196.TICKET_NUMBER = S.TICKET_NUMBER
                                                               AND TRUNC(S196.START_TIME) = TRUNC(S.START_TIME)
                                                               AND TRUNC(S196.FISCAL_DATE) = TRUNC(S.START_TIME)
                                                               AND AD196.SEQUENCE = AD.SEQUENCE + 1
                                                               AND AD196.DATA_ID IN (196)) FAIXA_FINAL
                                                          ,TRUNC(S.START_TIME)
                                                          ,S.STORE_KEY
                                                          ,S.POS_NUMBER
                                                          ,S.TICKET_NUMBER
                                                          ,(SELECT ES_DV.DATA_VALUE
                                                              FROM EMPORIUM.ANSWER_DATA ES_DV
                                                             WHERE TRUNC(ES_DV.START_TIME) = TRUNC(S.START_TIME)
                                                               AND ES_DV.STORE_KEY = S.STORE_KEY
                                                               AND ES_DV.POS_NUMBER = S.POS_NUMBER
                                                               AND ES_DV.TICKET_NUMBER = S.TICKET_NUMBER
                                                               AND ES_DV.DATA_ID = 194
                                                               AND ES_DV.ITEM_SEQUENCE = AD.ITEM_SEQUENCE) AS QTDE_KIT
                                                      FROM EMPORIUM.SALE        S
                                                          ,EMPORIUM.SALE_ITEM   SI
                                                          ,EMPORIUM.ANSWER_DATA AD
                                                     WHERE SI.STORE_KEY = S.STORE_KEY
                                                       AND SI.POS_NUMBER = S.POS_NUMBER
                                                       AND SI.TICKET_NUMBER = S.TICKET_NUMBER
                                                       AND SI.START_TIME = S.START_TIME
                                                       AND AD.STORE_KEY = S.STORE_KEY
                                                       AND AD.POS_NUMBER = S.POS_NUMBER
                                                       AND AD.TICKET_NUMBER = S.TICKET_NUMBER
                                                       AND AD.START_TIME = S.START_TIME
                                                       AND AD.ITEM_SEQUENCE = SI.SEQUENCE
                                                       AND AD.DATA_ID IN (195)
                                                       AND TRUNC(S.START_TIME) = TRUNC(ES_D.START_TIME) --'18-DEC-2023'
                                                       AND S.STORE_KEY = ES_D.STORE_KEY --2
                                                       AND S.POS_NUMBER = ES_D.POS_NUMBER --168
                                                       AND S.TICKET_NUMBER = ES_D.TICKET_NUMBER)) IK
                                            WHERE ES_D.SEQUENCE >= IK.FAIXA_INICIAL
                                              AND ES_D.SEQUENCE <= IK.FAIXA_FINAL
                                              AND ES_D.TYPE_PRICE = IK.TYPE_PRICE
                                              AND ES_D.TYPE_PRICE > 1) AS QUANTIDADE_CONJUNTO
                                         ,(SELECT FAIXA_INICIAL
                                             FROM ((SELECT SI.TYPE_PRICE
                                                          ,AD.ITEM_SEQUENCE AS FAIXA_INICIAL
                                                          ,(SELECT AD196.ITEM_SEQUENCE
                                                              FROM EMPORIUM.SALE S196
                                                             INNER JOIN EMPORIUM.SALE_ITEM SI196
                                                                ON SI196.STORE_KEY = S196.STORE_KEY
                                                               AND SI196.POS_NUMBER = S196.POS_NUMBER
                                                               AND SI196.TICKET_NUMBER = S196.TICKET_NUMBER
                                                               AND SI196.START_TIME = S196.START_TIME
                                                             INNER JOIN EMPORIUM.ANSWER_DATA AD196
                                                                ON AD196.STORE_KEY = S196.STORE_KEY
                                                               AND AD196.POS_NUMBER = S196.POS_NUMBER
                                                               AND AD196.TICKET_NUMBER = S196.TICKET_NUMBER
                                                               AND AD196.START_TIME = S196.START_TIME
                                                               AND AD196.ITEM_SEQUENCE = SI196.SEQUENCE
                                                             WHERE S196.STORE_KEY = S.STORE_KEY
                                                               AND S196.POS_NUMBER = S.POS_NUMBER
                                                               AND S196.TICKET_NUMBER = S.TICKET_NUMBER
                                                               AND TRUNC(S196.START_TIME) = TRUNC(S.START_TIME)
                                                               AND TRUNC(S196.FISCAL_DATE) = TRUNC(S.START_TIME)
                                                               AND AD196.SEQUENCE = AD.SEQUENCE + 1
                                                               AND AD196.DATA_ID IN (196)) FAIXA_FINAL
                                                      FROM EMPORIUM.SALE        S
                                                          ,EMPORIUM.SALE_ITEM   SI
                                                          ,EMPORIUM.ANSWER_DATA AD
                                                     WHERE SI.STORE_KEY = S.STORE_KEY
                                                       AND SI.POS_NUMBER = S.POS_NUMBER
                                                       AND SI.TICKET_NUMBER = S.TICKET_NUMBER
                                                       AND SI.START_TIME = S.START_TIME
                                                       AND AD.STORE_KEY = S.STORE_KEY
                                                       AND AD.POS_NUMBER = S.POS_NUMBER
                                                       AND AD.TICKET_NUMBER = S.TICKET_NUMBER
                                                       AND AD.START_TIME = S.START_TIME
                                                       AND AD.ITEM_SEQUENCE = SI.SEQUENCE
                                                       AND AD.DATA_ID IN (195)
                                                       AND TRUNC(S.START_TIME) = TRUNC(ES_D.START_TIME) --'18-DEC-2023'
                                                       AND S.STORE_KEY = ES_D.STORE_KEY --2
                                                       AND S.POS_NUMBER = ES_D.POS_NUMBER --168
                                                       AND S.TICKET_NUMBER = ES_D.TICKET_NUMBER)) IK
                                            WHERE ES_D.SEQUENCE >= IK.FAIXA_INICIAL
                                              AND ES_D.SEQUENCE <= IK.FAIXA_FINAL
                                              AND ES_D.TYPE_PRICE = IK.TYPE_PRICE
                                              AND ES_D.TYPE_PRICE > 1) AS FAIXA_INICIAL
                                         ,(SELECT AD.DATA_VALUE
                                             FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                                            WHERE AD.STORE_KEY = ES_D.STORE_KEY
                                              AND AD.POS_NUMBER = ES_D.POS_NUMBER
                                              AND AD.TICKET_NUMBER = ES_D.TICKET_NUMBER
                                              AND AD.DATA_ID = 33
                                              AND trunc(AD.START_TIME) = trunc(ES_D.START_TIME)) AS CODIGO_PRE_VENDA
                                     FROM EMPORIUM.EXPDET_SALE_ITEM ES_D
                                    WHERE TRUNC(ES_D.START_TIME) = TRUNC(R1.DATA_VENDA)
                                      AND ES_D.STORE_KEY = R1.NUMERO_LOJA
                                      AND ES_D.POS_NUMBER = R1.NUMERO_PDV
                                      AND ES_D.TICKET_NUMBER = R1.NUMERO_CUPOM
                                    ORDER BY 5)
                        LOOP
                           --
                           --CASO EXISTA NO MÓDULO DE CANCELAMENTO DA CONECTO, NÃO POSSO PROCESSAR O ITEM, POIS JÁ POSSUI
                           --UM ITEM COM A SEQUÊNCIA DO CANCELAMENTO
                           BEGIN
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                             
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1010, 'EMPORIUM.EXPDET_ANSWER_DATA');
                              SELECT COUNT(*)
                                INTO intContador
                                FROM EMPORIUM.EXPDET_ANSWER_DATA E
                               WHERE E.STORE_KEY = R2.NUMERO_LOJA
                                 AND E.POS_NUMBER = R2.NUMERO_PDV
                                 AND E.TICKET_NUMBER = R2.NUMERO_CUPOM
                                 AND E.DATA_ID = 162 --FIXO DE ACORDO COM O FERNANDO - QUANDO O ITEM É CANCELADO - 20/SEP/2023 ás 18:31: Conversa skype grupo integração Conecto
                                 AND E.DATA_VALUE = R2.SEQUENCIA - 1;
                           EXCEPTION
                              WHEN OTHERS THEN
                                 intContador := 0;
                           END;
                           IF intContador > 0 THEN
                              GOTO PROXIMO_ITEM;
                           END IF;
                           if intPreVenda = 0 then
                              intPreVenda := nvl(r2.codigo_pre_venda, 0);
                              intPreVendaVinculo  := nvl(r2.codigo_pre_venda, 0); -- Caso 45187 Danilo 14/11/2025                              
                           end if;
                           vDetalhe := ' - Data: ' || r2.data_venda || ' - Loja: ' || R1.NUMERO_LOJA || ' - PDV: ' || r2.numero_pdv || ' - Cupom:' || r2.numero_cupom || ' - Seq.: ' || r2.sequencia;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                             
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1033, 'aliquota/tributacao');
                              Select aliq.aliquota
                                    ,aliq.tipo
                                into vAliquota
                                    ,vTipoAliq
                                from aliquota   aliq
                                    ,tributacao trib
                               where aliq.codigo = trib.aliquota
                                 and trib.equipamento = 19
                                 and aliq.reducao = 0
                                 and trib.codigo = TRIM(R2.CODIGO_NATUREZA);
                           Exception
                              when no_data_found Then
                                 vAliquota := '0';
                                 vTipoAliq := 'I';
                           End;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                          
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1053, 'Produtos_ean');
                              -- danilo 67806
                              select Quantidade
                                into vQtdEmb
                                from Produtos_ean
                               where CodBarra = r2.codigo_ean
                                 and rownum <= 1;
                           Exception
                              when no_data_found Then
                                 vQtdEmb := '0';
                           End;
                           If nvl(r2.codigo_conjunto_produto, 0) > 0 Then
                              /*foi colocado -1 devido a problema de movimentacao de compostos descessarios exe: fardo de coca com 6. a alteracao foi feita apos a apuracao das cestas de natal Viotti autorizou a alteracao alterado por danilo bruneli*/
                              begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1068, 'produtos_compostos/produtos_compostos_tipo');
                                 select pct.contabilizavendaprincipal
                                   into intcontabilizavendaprincipal
                                   from produtos_compostos      pc
                                       ,produtos_compostos_tipo pct
                                  where 1 = 1
                                    and pc.tipo = pct.codigo
                                    and pc.loja = intLojaCFG
                                    and pc.codigo = r2.codigo_conjunto_produto;
                              exception
                                 when no_data_found then
                                    intcontabilizavendaprincipal := 0;
                              end;
                              if intcontabilizavendaprincipal = 1 then
                                 BEGIN
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1085, 'PRODUTOS_MOVIMENTO_COMPOSTOS');
                                    SELECT PMC.SEQUENCIACOMPOSTO
                                      INTO intSequenciaComposto
                                      FROM PRODUTOS_MOVIMENTO_COMPOSTOS PMC
                                     WHERE PMC.DATA = R2.DATA_VENDA
                                       AND PMC.LOJA = intCodigoLoja
                                       AND PMC.PDV = R2.NUMERO_PDV
                                       AND PMC.CUPOM = R2.NUMERO_CUPOM
                                       AND PMC.PRODUTOPRINCIPAL = R2.CODIGO_CONJUNTO_PRODUTO
                                       AND PMC.FAIXA_CONECTO = R2.FAIXA_INICIAL
                                       AND ROWNUM = 1;
                                 EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                       BEGIN
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1101, 'PRODUTOS_MOVIMENTO_COMPOSTOS');
                                          SELECT NVL(MAX(PMC.SEQUENCIACOMPOSTO), 0) + 1
                                            INTO intSequenciaComposto
                                            FROM PRODUTOS_MOVIMENTO_COMPOSTOS PMC
                                           WHERE PMC.DATA = R2.DATA_VENDA
                                             AND PMC.LOJA = intCodigoLoja
                                             AND PMC.PDV = R2.NUMERO_PDV
                                             AND PMC.CUPOM = R2.NUMERO_CUPOM;
                                       EXCEPTION
                                          WHEN NO_DATA_FOUND THEN
                                             intSequenciaComposto := 1;
                                       END;
                                 END;
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1117, 'Produtos_Movimento_Compostos');
                                 /*Caso 150 - Danilo - 29/10/2012*/
                                 Insert Into Produtos_Movimento_Compostos
                                    (Loja
                                    ,Data
                                    ,Pdv
                                    ,Cupom
                                    ,Item
                                    ,Sequencia
                                    ,Quantidade
                                    ,Produtoprincipal
                                    ,Sequenciacomposto
                                    ,Situacao
                                    ,FAIXA_CONECTO)
                                 Values
                                    (intCodigoLoja
                                    ,r2.Data_Venda
                                    ,r2.Numero_Pdv
                                    ,r2.Numero_Cupom
                                    ,r2.Codigo_Produto
                                    ,r2.Sequencia
                                    ,r2.quantidade_conjunto
                                    ,r2.codigo_conjunto_produto
                                    ,intSequenciaComposto --r2.sequencia_conjunto
                                    ,case when(r2.situacao_detalhe in (2, 4, 5)) then 'C' when R1.SITUACAO_CAPA IN (2, 9) then 'C' else 'P' end
                                    ,R2.FAIXA_INICIAL);
                                 -- Vari vel que indica o processamento do composto principal
                                 -- que foi explodido na venda por PDV para fazer controle de venda
                                 -- e de estoque
                                 vProcessaConjunto := 1;
                                 if R1.SITUACAO_CAPA IN (2, 9) then
                                    VCupomCanceladoConjuto := 1;
                                 else
                                    VCupomCanceladoConjuto := 0;
                                 End If;
                              End If;
                           End If;
                           intEcommerce := 0;
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1156, 'PEDIDOS/OPERACOES_1/PEDIDOS_ITENS');
                           SELECT COUNT(*)
                             into vCont
                             FROM PEDIDOS       P
                                 ,OPERACOES_1   OP
                                 ,PEDIDOS_ITENS PI
                            WHERE P.OPERACAO = OP.CODIGO
                              AND P.CHAVE = PI.CHAVEPEDIDO
                              and op.ecommerce = 1
                              AND P.CHAVE = intPreVenda
                              AND PI.CODIGO = r2.codigo_produto;
                           if vCont > 0 then
                              intEcommerce := 1;
                           end if;
                           intClubeVM := 0;
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1156, 'EMPORIUM.EXPDET_SALE_DISCOUNT');
                           SELECT COUNT(*)
                             into vCont
                             FROM EMPORIUM.EXPDET_SALE_DISCOUNT D
                            WHERE EXISTS (SELECT 1
                                     from emporium.EXPDET_ANSWER_DATA AD
                                    where AD.DATA_ID = 102
                                      AND AD.TICKET_NUMBER = D.TICKET_NUMBER
                                      AND AD.POS_NUMBER = D.POS_NUMBER
                                      AND AD.STORE_KEY = D.STORE_KEY
                                      AND TRUNC(AD.START_TIME) = TRUNC(D.START_TIME)
                                      AND AD.DATA_VALUE LIKE '900001099%')
                              AND D.TICKET_NUMBER = R2.NUMERO_CUPOM
                              AND D.POS_NUMBER = R2.NUMERO_PDV
                              AND D.STORE_KEY = R2.NUMERO_LOJA
                              AND TRUNC(D.START_TIME) = TRUNC(R2.DATA_VENDA)
                              AND D.ITEM_SEQUENCE = R2.SEQUENCIA - 1;

                           --Caso 35020 - Caio Guelre - 08/03/2024
                           --SE O ITEM NÃO TEM MEU VERDEMAR NOS MOLDES NORMAIS, PROCURA DIRETAMENTE NA TABELA EXPDET_ANSWER_DATA
                           IF vCont = 0 THEN
                              BEGIN
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1197, 'EMPORIUM.EXPDET_ANSWER_DATA');
                                 SELECT COUNT(*)
                                   INTO vCont
                                   FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                                  where AD.DATA_ID = 102
                                    AND AD.TICKET_NUMBER = R2.NUMERO_CUPOM
                                    AND AD.POS_NUMBER = R2.NUMERO_PDV
                                    AND AD.STORE_KEY = R2.NUMERO_LOJA
                                    AND TRUNC(AD.START_TIME) = TRUNC(R2.DATA_VENDA)
                                    AND AD.ITEM_SEQUENCE = R2.SEQUENCIA - 1
                                    AND AD.DATA_VALUE LIKE '900001099%';
                               EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                         vCont := 0;
                               END;
                           END IF;

                           begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1217, 'verdemar.import_promotion_category_log');
                              SELECT COUNT(*)
                                INTO vCont1
                                from verdemar.import_promotion_category_log ip
                               where promotion_key = (SELECT substr(ad.data_value,0,instr(ad.data_value,'|')-1 ) a
                                                        FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                                                       where AD.DATA_ID = 102
                                                         AND AD.TICKET_NUMBER =  R2.NUMERO_CUPOM
                                                         AND AD.POS_NUMBER = R2.NUMERO_PDV
                                                         AND AD.STORE_KEY = R2.NUMERO_LOJA
                                                         AND TRUNC(AD.START_TIME) = TRUNC(R2.DATA_VENDA)
                                                         AND AD.ITEM_SEQUENCE = R2.SEQUENCIA - 1
                                                     )
                                 and ip.cst_type_key = 1099
                                 and ip.store_key = R2.NUMERO_LOJA;
                           EXCEPTION
                              WHEN others THEN
                                 vCont1 := 0;
                           END;

                           --Caso 123456 - Caio Guelre - 19/03/2025 - MERCA FÁCIL
                           --É necessário que para o MERCA FÁCIL os produtos sejam marcados como CLUBE VM, pois somente assim fará apuração do contrato.
                           BEGIN
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1242, 'EMPORIUM.EXPDET_SALE_PROMOTION_ITEM');
                              SELECT COUNT(*)
                                INTO intMercaFacil
                                FROM EMPORIUM.EXPDET_SALE_PROMOTION_ITEM P
                               WHERE P.PROMOTION_KEY = 1027
                                 AND P.TICKET_NUMBER =  R2.NUMERO_CUPOM
                                 AND P.POS_NUMBER = R2.NUMERO_PDV
                                 AND P.STORE_KEY = R2.NUMERO_LOJA
                                 AND P.FISCAL_DATE = TRUNC(R2.DATA_VENDA)
                                 AND P.PLU_ID = R2.CODIGO_PRODUTO;
                           EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                     intMercaFacil := 0;
                           END;

                           if R2.TYPE_PRICE = 1099 OR vCont > 0 or vCont1 > 0 OR intMercaFacil > 0 then
                              intClubeVM := 1;
                           end if;

                         --Gustavo.Santiago -- marcar na socin detalhe que a venda
                         --veio de um terceiro preço
                         -- esse IN de baixo, é porque se tiver um produto terceiro
                         -- todos os itens do cupom do mesmo produto é terceiro tbm
                         BEGIN
                             /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                             PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                             PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1268, 'EMPORIUM.EXPDET_ANSWER_DATA');
                             SELECT COUNT(*)
                             INTO vCont
                             FROM EMPORIUM.EXPDET_ANSWER_DATA AD
                             where AD.DATA_ID = 102
                               AND AD.TICKET_NUMBER = R2.NUMERO_CUPOM
                               AND AD.POS_NUMBER = R2.NUMERO_PDV
                               AND AD.STORE_KEY = R2.NUMERO_LOJA
                               AND TRUNC(AD.START_TIME) = TRUNC(R2.DATA_VENDA)
                               AND AD.DATA_VALUE LIKE '123%'
                               AND AD.ITEM_SEQUENCE  in (
                                                           select ESI.Sequence
                                                           from EMPORIUM.EXPDET_SALE_ITEM ESI
                                                           where ESI.POS_NUMBER = AD.Pos_Number and
                                                                 ESI.TICKET_NUMBER = AD.TICKET_NUMBER and
                                                                 ESI.STORE_KEY = AD.STORE_KEY and
                                                                 TRUNC( ESI.START_TIME) =  TRUNC(AD.START_TIME) and
                                                                 ESI.PLU_ID = R2.CODIGO_PRODUTO );
                         EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                   vCont := 0;
                           END;
                           intTerceiroPreco := 0;
                           if vCont > 0 then
                              intTerceiroPreco := 1;
                           end if;

                           /*
                           SELECT COUNT(*)
                             into vCont
                             FROM emporium.expdet_answer_data ad
                            where ad.store_key = r2.numero_loja
                              and ad.pos_number = r2.numero_pdv
                              and ad.ticket_number = r2.numero_cupom
                              and trunc(ad.start_time) = TRUNC(R2.DATA_VENDA)
                              and ad.data_id = 102
                              and ad.item_sequence = R2.SEQUENCIA - 1;
                           if vCont > 0 then
                              intClubeVM := 1;
                           end if;
                           */
                           /*If (R1.SITUACAO_CAPA NOT IN (2, 9)) then
                              --If (r2.total + r2.ajuste_positivo - r2.ajuste_negativo = 0) then
                              If (r2.total + r2.ajuste_positivo - r2.ajuste_negativo = 0) then
                                 prc_raiseapplication('Cupom possui itens com o valor total zerado considerando o ajuste positivo e negativo!');
                              End if;
                           End if;*/
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1317, 'socin_detalhes_cupom_grava');
                           socin_detalhes_cupom_grava(R2.Acrescimo, -- Acrescimo
                                                      r2.ajuste_negativo,
                                                      r2.ajuste_positivo,
                                                      vAliquota, -- Aliquota
                                                      0, -- Anula Desconto
                                                      r2.codigo_produto,
                                                      r2.codigo_ean,
                                                      r2.numero_cupom,
                                                      r2.data_venda,
                                                      '', -- Dependencia 1
                                                      '', -- Dependencia 2
                                                      '', -- Dependencia 3
                                                      r2.desconto,
                                                      intCodigoLoja,
                                                      r2.motivo_cancelamento,
                                                      r2.numero_pdv,
                                                      case when vAcertaEan = '1' then(r2.total / (vQtdEmb * r2.quantidade)) else r2.preco end,
                                                      case when vAcertaEan = '1' then vQtdEmb * r2.quantidade else r2.quantidade end,
                                                      r2.sequencia,
                                                      case when(r2.situacao_detalhe in (2, 4, 5)) then 'C' when R1.SITUACAO_CAPA IN (2, 9) then 'C' else 'P' end, r2.total, '', -- Vale Produto
                                                      r2.vendedor,
                                                      vReprocesso, -- Reprocesso
                                                      '', -- Pedido PDV
                                                      r2.usuario_cancelou,
                                                      vTipoAliq, -- Tipo da Aliquota
                                                      r2.tipo_desconto,
                                                      R1.HORA_VENDA,
                                                      R1.MELIUZ,
                                                      intEcommerce,
                                                      intClubeVM,
                                                      nvl(r2.codigo_conjunto_produto, 0),
                                                      intTerceiroPreco);
                           /*IF R2.SITUACAO_DETALHE = 2 THEN --SE FOR CANCELADO
                              BEGIN
                                 SELECT *
                                   FROM EMPORIUM.EXPDET_ANSWER_DATA E
                                  WHERE E.STORE_KEY = R2.NUMERO_LOJA
                                    AND E.POS_NUMBER = R2.NUMERO_PDV
                                    AND E.TICKET_NUMBER = R2.NUMERO_CUPOM
                                    AND E.DATA_ID = 162 --FIXO DE ACORDO COM O FABRÍCIO - QUANDO O ITEM É CANCELADO
                                    AND E.DATA_VALUE = R2.SEQUENCIA
                              EXCEPTION
                              END;
                           END IF;*/
                          /*IF R1.SITUACAO_CAPA = 2 THEN
                              vDetalhesTotalBruto := R1.TOTAL_BRUTO;
                           ELSE*/ -- GABRIEL FONSECA 06/10/2025 - ALTERAÇÃO PARA REGISTRAR CAPA COM PREÇO TOTAL DIFERENTE DA SOMA DOS ITENS
                              --SOMA SOMENTE SE O ITEM N O FOR CANCELADO
                           if r2.situacao_detalhe NOT in (2, 4, 5) Then
                              vDetalhesTotalBruto := vDetalhesTotalBruto + r2.total + r2.desconto;
                           END IF;
--                         END IF;
                           If (r1.total_cancelado > 0) Then
                              vTotalDetalhe := vTotalDetalhe;
                           Else
                              if (r2.situacao_detalhe in (2, 4, 5)) Then
                                 vTotalDetalhe := vTotalDetalhe;
                              Else
                                 vTotalDetalhe := vTotalDetalhe + r2.total;
                              End If;
                           End If;
                           <<PROXIMO_ITEM>>
                           intContador := 0;
                        End Loop;
                     Exception
                        when Others then
                           RollBack;
                           vErro          := 'Erro ao Importar Detalhe - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                           strErroDetalhe := 'Erro ao Importar Detalhe - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                           -- prc_raiseapplication(vErro);
                           -- Tratamento para deixar somente o ultimo log de um cupom
                           If vLogImp = 'N' Then
                              DELETE FROM LOG_IMPORTACAO
                               WHERE TRUNC(DATA) = TRUNC(R1.DATA_VENDA)
                                 AND LOJA = r1.Numero_loja
                                 AND PDV = R1.NUMERO_PDV
                                 AND CUPOM = R1.NUMERO_CUPOM
                                 AND CONECTO = 1;
                              BEGIN
                                 SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                              EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                    vCont := 0;
                              END;
                              IF vCont = 0 THEN
                                 strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                 UPDATE EMPORIUM.EXPDET_SALE ES
                                    SET ES.STATUS = 3
                                  WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                    AND ES.STORE_KEY = R1.NUMERO_LOJA
                                    AND ES.POS_NUMBER = R1.NUMERO_PDV
                                    AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                 INSERT INTO LOG_IMPORTACAO
                                    (CHAVE
                                    ,REGISTRO
                                    ,TABELA
                                    ,ERROBANCO
                                    ,VERIFICADO
                                    ,DATA
                                    ,LOJA
                                    ,PDV
                                    ,CUPOM
                                    ,CONECTO
                                    ,ERROBANCO_DETALHES)
                                 values
                                    (log_importacao_seq.nextval
                                    ,Substr(vDetalhe, 1, 200)
                                    ,'EMPORIUM.EXPDET_SALE_ITEM'
                                    ,Substr(vErro, 1, 200)
                                    ,0
                                    ,R1.DATA_VENDA
                                    ,R1.NUMERO_LOJA
                                    ,R1.NUMERO_PDV
                                    ,R1.NUMERO_CUPOM
                                    ,1
                                    ,strErroDetalhe);
                              END IF;
                              vLogImp := 'S';
                              commit;
                           End If;
                     End; -- Excecao do Detalhe
                  End If;
                  --End If;
                  --If vInserePdv = 1 Then
                  Begin
                     if (intPreVenda > 0) then
                        /* Pre-Venda - DAV - movimentar o item principal -- inicio */
                        vCont             := 0;
                        intCodigoAnterior := 0;
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1449, 'pedidos_itens/produtos_compostos_itens/Produtos/Setor');
                        for itens in (Select T.*
                                            ,rownum as sequenciaCupom
                                        from (select NVL(pci.codigo, -1) Codigo_Conjunto_Produto
                                                    ,NVL(pci.produto, -1) Codigo_Produto
                                                    ,pi.quantidade Quantidade_Conjunto
                                                from pedidos_itens pi
                                                left outer join produtos_compostos_itens pci
                                                  on pi.codigo = pci.codigo
                                                 and pci.loja = intLojaCFG
                                                Left Outer Join Produtos Prod
                                                  On Prod.Codigo = Pci.Produto
                                                Left Outer Join Setor S
                                                  On S.Codigo = Prod.Setor
                                                 And S.BLOQUEIAPRODUTOSPDV = 'N' --Caso 8236 - Caio Guelre - 21/11/2014
                                               where pi.chavepedido = intPreVenda
                                                 AND EXISTS (SELECT 1
                                                        FROM EMPORIUM.EXPDET_SALE_ITEM ES_D
                                                       WHERE ES_D.TICKET_NUMBER = R1.NUMERO_CUPOM
                                                         AND TRUNC(ES_D.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                         AND ES_D.STORE_KEY = R1.NUMERO_LOJA
                                                         AND ES_D.POS_NUMBER = R1.NUMERO_PDV
                                                         AND ES_D.PLU_ID = PCI.PRODUTO)
                                               order by pi.codigo
                                                       ,pci.produto) T)
                        LOOP
                           If itens.codigo_conjunto_produto <> -1 Then
                              if intCodigoAnterior = 0 then
                                 intCodigoAnterior := itens.codigo_conjunto_produto;
                                 vCont             := 1;
                              end if;
                              if intCodigoAnterior <> itens.codigo_conjunto_produto then
                                 vCont             := vCont + 1;
                                 intCodigoAnterior := itens.codigo_conjunto_produto;
                              end if;
                              begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                   
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1487, 'produtos_compostos/produtos_compostos_tipo');
                                 select pct.contabilizavendaprincipal
                                   into intcontabilizavendaprincipal
                                   from produtos_compostos      pc
                                       ,produtos_compostos_tipo pct
                                  where 1 = 1
                                    and pc.tipo = pct.codigo
                                    and pc.loja = intLojaCFG
                                    and pc.codigo = itens.codigo_conjunto_produto;
                              exception
                                 when no_data_found then
                                    intcontabilizavendaprincipal := 0;
                              end;
                              if intcontabilizavendaprincipal = 1 then
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                      
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1503, 'Produtos_Movimento_Compostos');
                                 Insert Into Produtos_Movimento_Compostos
                                    (Loja
                                    ,Data
                                    ,Pdv
                                    ,Cupom
                                    ,Item
                                    ,Sequencia
                                    ,Quantidade
                                    ,Produtoprincipal
                                    ,Sequenciacomposto
                                    ,Situacao)
                                 Values
                                    (intCodigoLoja
                                    ,r1.Data_Venda
                                    ,r1.Numero_Pdv
                                    ,r1.Numero_Cupom
                                    ,itens.Codigo_Produto
                                    ,itens.Sequenciacupom
                                    ,itens.quantidade_conjunto
                                    ,itens.codigo_conjunto_produto
                                    ,vCont
                                    ,Case
                                        When R1.SITUACAO_CAPA IN (2, 9) Then
                                         'C'
                                        Else
                                         'P'
                                     End);
                                 -- Variavel que indica o processamento do composto principal
                                 -- que foi explodido na venda por PDV para fazer controle de venda
                                 -- e de estoque
                                 vProcessaConjunto := 1;
                                 if R1.SITUACAO_CAPA IN (2, 9) then
                                    VCupomCanceladoConjuto := 1;
                                 else
                                    VCupomCanceladoConjuto := 0;
                                 End If;
                              End If;
                           end if;
                        end loop;
                     End If; /* Pre-Venda - DAV - movimentar o item principal -- fim */
                     -- Tratamento para Controlar o Estoque dos Produtos Principais
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                      
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1547, 'PRODUTOS_MOVIMENTO_COMPOSTOS');
                     For r10 in (SELECT DISTINCT LOJA
                                                ,DATA
                                                ,PDV
                                                ,CUPOM
                                                ,PRODUTOPRINCIPAL
                                                ,SEQUENCIACOMPOSTO
                                                ,QUANTIDADE
                                                ,SITUACAO
                                   FROM PRODUTOS_MOVIMENTO_COMPOSTOS
                                  WHERE LOJA = intCodigoLoja
                                    AND DATA = r1.data_venda
                                    AND PDV = r1.numero_pdv
                                       --and cupom=0
                                    AND CUPOM = r1.numero_cupom
                                  order by SEQUENCIACOMPOSTO)
                     loop
                        /*Caso 8413 - Danilo -- inicio*/
                        if r10.situacao = 'C' then
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                         
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1568, 'PRC_ESTOQUE_COMP_PRINCIPAL');
                           PRC_ESTOQUE_COMP_PRINCIPAL(r10.loja, r10.pdv, r10.cupom, r10.sequenciacomposto, r10.produtoprincipal, r10.quantidade, r10.data, 'C', 'N');
                           PRC_ESTOQUE_COMP_PRINCIPAL(r10.loja, r10.pdv, r10.cupom, r10.sequenciacomposto, r10.produtoprincipal, r10.quantidade, r10.data, 'D', 'S');
                        end if;
                        if r10.situacao = 'P' then
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                            
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1575, 'PRC_ESTOQUE_COMP_PRINCIPAL');
                           PRC_ESTOQUE_COMP_PRINCIPAL(r10.loja, r10.pdv, r10.cupom, r10.sequenciacomposto, r10.produtoprincipal, r10.quantidade, r10.data, 'D', 'N');
                        end if;
                        /*Caso 8413 - Danilo -- Fim */
                     End Loop;
                     If R1.SITUACAO_CAPA IN (2, 9) Then
                        vTotalFinalizadora := vTotalCapa;
                     Else
                        vTotalFinalizadora := 0;
                     End If;
                     strMsmErroAdiciona := 'OK';
                     fltValorDoacao     := 0;

                     /*Caso 40806 - Danilo -- inicio*/
                    blnFinDaWeb := 0;

                    IF intPreVenda > 0 THEN
                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                               
                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1593, 'EMPORIUM.EXPDET_SALE_MEDIA');

                    -- Conta mídias 9 x não-9 no POS (mantido do jeito antigo)
                    SELECT NVL(SUM(CASE WHEN ES_F.MEDIA_ID = 9 THEN 1 ELSE 0 END),0),
                            NVL(SUM(CASE WHEN ES_F.MEDIA_ID <> 9 THEN 1 ELSE 0 END),0)
                        INTO intContador,
                            intQtdeFinCupom
                        FROM EMPORIUM.EXPDET_SALE_MEDIA ES_F
                        WHERE TRUNC(ES_F.START_TIME) >= TRUNC(R1.DATA_VENDA)
                        AND TRUNC(ES_F.START_TIME) <  TRUNC(R1.DATA_VENDA + 1)
                        AND ES_F.STORE_KEY      = R1.NUMERO_LOJA
                        AND ES_F.POS_NUMBER     = R1.NUMERO_PDV
                        AND ES_F.TICKET_NUMBER  = R1.NUMERO_CUPOM
                        AND ES_F.AMOUNT > 0;
                    -- and es_f.media_id = 9;

                    -- Victor Lustosa - 1 : valida e-commerce (FIN 1/9)
                    BEGIN
                        SELECT NVL(SUM(CASE WHEN D.FIN IN (1, 9) THEN 1 ELSE 0 END), 0) AS QTDE_FIN_WEB,
                                NVL(SUM(CASE WHEN D.FIN NOT IN (1, 9) THEN 1 ELSE 0 END), 0) AS QTDE_FIN_OUTRAS
                            INTO intContadorEcommerce,
                                intQtdeFinCupomEcommerce
                            FROM (
                                SELECT D.FIN
                                    FROM VERDEMAR.PEDIDOSECOMMERCE PE
                                    JOIN VERDEMAR.TB_BDC_FIN_DAV D
                                    ON D.COD_DAV = PE.CHAVE_PEDIDO_SUPERUS
                                WHERE PE.CHAVE_PEDIDO_SUPERUS = intPreVenda
                                    AND PE.RETIRADA_LOJA        = 1
                                    AND PE.STATUS               = 'S'

                                UNION ALL

                                SELECT D.FIN
                                    FROM VERDEMAR.PEDIDOS_ECOMMERCE PE
                                    JOIN VERDEMAR.TB_BDC_FIN_DAV D
                                    ON D.COD_DAV = PE.PEDIDO_SUPERUS
                                WHERE PE.PEDIDO_SUPERUS = intPreVenda
                                    AND PE.ENTREGA        = 0
                                    AND PE.STATUS         = 'S'
                                );
                    EXCEPTION
                        WHEN OTHERS THEN
                            intContadorEcommerce     := 0;
                            intQtdeFinCupomEcommerce := 0;
                    END;

                    -- guarda o pedido e-commerce quando existir
                    IF intContadorEcommerce > 0 THEN
                        parPedidoE := intPreVenda;
                    END IF;

                    -- AQUI AINDA ESTÁ NO MODELO ANTIGO (só mídia 9 no POS dispara web)
                    IF intContador > 0 THEN
                        blnFinDaWeb := 1;

                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                               
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1612, 'PEDIDOS_ECOMMERCE/pedidos/finalizadoras');

                        SELECT COUNT(*)
                            INTO intContador
                            FROM (
                                SELECT fin.finalizadorafrente,
                                        REPLACE(PG.PAYMENTID, '-', '') NUMERO_AUTORIZACAO,
                                        SUM(NVL(pv.valor, ped.valor)) AS valor,
                                        'V' ORIGEM_PEDIDO
                                    FROM PEDIDOS_ECOMMERCE            P
                                        ,PEDIDOS_ECOMMERCE_PAGAMENTOS PG
                                        ,pedidos                      ped
                                        ,condicoes_pagamento          condpgt
                                        ,finalizadoras                fin
                                        ,pedidos_vencimentos          pv
                                WHERE (CASE
                                            WHEN intRestaurante = 1 THEN
                                            P.PEDIDO_SUPERUS_RESTAURANTE
                                            ELSE
                                            P.PEDIDO_SUPERUS
                                        END) = intPreVenda
                                    AND PG.CHAVEPEDIDO(+) = P.CHAVE
                                    AND P.PEDIDO_SUPERUS  = ped.chave
                                    AND condpgt.codigo    = ped.condicaopagamento
                                    AND condpgt.finalizadora = fin.codigo
                                    AND P.STATUS = 'S'
                                    AND pv.chavepedido(+) = ped.chave
                                GROUP BY fin.finalizadorafrente,
                                            REPLACE(PG.PAYMENTID, '-', '')

                                UNION

                                SELECT CASE
                                            WHEN UPPER(pe1.tipo_pedido) <> 'COMPRA' THEN
                                            5
                                            ELSE
                                            e.finalizadorafrente
                                        END AS finalizadorafrente,
                                        REPLACE(b.TID, '-', '') NUMERO_AUTORIZACAO,
                                        DECODE(d.codigo, 671, pe1.valor_desconto, 0) + a.valor AS valor,
                                        pe1.origem_pedido
                                    FROM pedidospagamentosecommerce A
                                INNER JOIN PEDIDOSECOMMERCE pe1
                                    ON pe1.id = a.pedido_id
                                    LEFT JOIN pedidosdetpagamentosecommerce B
                                    ON A.ID = B.PAGAMENTO_ID
                                INNER JOIN pedidosdetfaturamentoecommerce C
                                    ON A.ID = C.PAGAMENTO_ID
                                INNER JOIN CONDICOES_PAGAMENTO D
                                    ON d.codigo = c.valor
                                INNER JOIN finalizadoras e
                                    ON e.codigo = d.finalizadora
                                WHERE pe1.chave_pedido_superus = intPreVenda

                                UNION

                                SELECT 5 AS finalizadorafrente,
                                        NULL NUMERO_AUTORIZACAO,
                                        pe1.valor_desconto,
                                        pe1.origem_pedido
                                    FROM pedidospagamentosecommerce A
                                INNER JOIN PEDIDOSECOMMERCE pe1
                                    ON pe1.id = a.pedido_id
                                    LEFT JOIN pedidosdetpagamentosecommerce B
                                    ON A.ID = B.PAGAMENTO_ID
                                INNER JOIN pedidosdetfaturamentoecommerce C
                                    ON A.ID = C.PAGAMENTO_ID
                                INNER JOIN CONDICOES_PAGAMENTO D
                                    ON d.codigo = c.valor
                                INNER JOIN finalizadoras e
                                    ON e.codigo = d.finalizadora
                                INNER JOIN pedidos ped
                                    ON ped.chave = pe1.chave_pedido_superus
                                WHERE pe1.chave_pedido_superus = intPreVenda
                                    AND (pe1.valor_desconto - ped.descontototalitem) > 0
                                    AND d.codigo <> 671
                                );

                        IF intContador = 0 THEN  -- caso TOTEM
                            blnFinDaWeb := 0;
                            intPreVenda := 0;
                        END IF;
                    END IF;
                    END IF;
                    /*Caso 40806 - Danilo -- fim*/

                     /*Caso 40806 - Danilo -- fim*/

                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                               
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1696, 'EMPORIUM.EXPDET_SALE_MEDIA');
                     For r2_2 in (SELECT TRUNC(ES_F.START_TIME) AS DATA_MOVIMENTO
                                 ,(SELECT ES.CASHIER_ID
                                     FROM EMPORIUM.EXPDET_SALE ES
                                    WHERE ES.STORE_KEY = ES_F.STORE_KEY
                                      AND ES.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND ES.SALE_TYPE <> 106) AS CODIGO_OPERADOR
                                 ,ES_F.STORE_KEY AS NUMERO_LOJA
                                 ,ES_F.POS_NUMBER AS NUMERO_PDV
                                 ,2 AS TIPO_MOVIMENTO
                                 ,ES_F.TICKET_NUMBER AS NUMERO_CUPOM
                                 ,(ES_F.SEQUENCE + 1) AS SEQUENCIA
                                 ,ES_F.SEQUENCE AS SEQUENCIA_CONECTO
                                 --,CASE WHEN ES_F.MEDIA_ID > 24 THEN 9 ELSE ES_F.MEDIA_ID END AS CODIGO_FINALIZADORA
                                 ,ES_F.MEDIA_ID AS CODIGO_FINALIZADORA
                                 ,(SELECT FIN.NOME FROM FINALIZADORAS FIN WHERE FIN.CODIGO = ES_F.MEDIA_ID) AS DESC_FINALIZADORA
                                 ,ES_F.AMOUNT AS VALOR
                                 ,NVL((SELECT ABS(SUM(ES_FF.AMOUNT)) AS TROCO
                                        FROM EMPORIUM.EXPDET_SALE_MEDIA ES_FF
                                       WHERE ES_FF.STORE_KEY = ES_F.STORE_KEY
                                         AND ES_FF.POS_NUMBER = ES_F.POS_NUMBER
                                         AND ES_FF.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                         AND ES_FF.AMOUNT < 0
                                         AND ES_FF.MEDIA_ID = ES_F.MEDIA_ID
                                            --AND ES_FF.SEQUENCE = ES_F.SEQUENCE + 1 --retirado por danilo no dia 01/11/2023 apos alinhamento por skype por Everton no grupo da virada conector
                                            --03/11/2023 - Caio Guelre - ACRESCENTADO REGRA DE PEGAR A ÚLTIMA SEQUÊNCIA DA FINALIZADORA (QUANDO MAIS DE UMA) PARA CONSIDERAR O TROCO
                                         AND ES_F.SEQUENCE = (SELECT MAX(ES_FT.SEQUENCE)
                                                                FROM EMPORIUM.EXPDET_SALE_MEDIA ES_FT
                                                               WHERE TRUNC(ES_FT.START_TIME) = TRUNC(ES_F.START_TIME)
                                                                 AND ES_FT.STORE_KEY = ES_F.STORE_KEY
                                                                 AND ES_FT.POS_NUMBER = ES_F.POS_NUMBER
                                                                 AND ES_FT.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                                                 AND ES_FT.AMOUNT > 0
                                                                 AND ES_FT.MEDIA_ID = ES_F.MEDIA_ID)), 0) AS TROCO
                                 ,'D' AS TIPO_TROCO
                                 ,ES_F.BRANCH AS NUMERO_CONTA
                                 ,ES_F.CHECK_NUMBER AS NUMERO_CHEQUE
                                 ,NVL(ES_F.ACCOUNT, 0) AS CODIGO_AGENCIA
                                 ,NVL(ES_F.BANK, 0) AS CODIGO_BANCO
                                 ,ES_F.DATE_DUE AS DATA_DEPOSITO
                                 ,NULL AS AUTENTICA
                                 ,REPLACE((SELECT AD.DATA_VALUE
                                            FROM EMPORIUM.EXPDET_sale_media_data AD
                                           WHERE AD.DATA_ID = 104
                                             AND AD.STORE_KEY = ES_F.STORE_KEY
                                             AND AD.POS_NUMBER = ES_F.POS_NUMBER
                                             AND AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                             AND TRUNC(AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                             and ad.sequence = es_f.sequence), '*********', '******') AS NUMERO_CARTAO
                                 ,(SELECT ES_AD.DATA_VALUE
                                     FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                    WHERE ES_AD.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND ES_AD.DATA_ID = 491
                                      AND ROWNUM <= 1) NUMERO_CPF_CNPJ
                                 ,(SELECT ES_M.DATA_VALUE --1
                                     FROM EMPORIUM.EXPDET_ANSWER_DATA ES_M
                                    WHERE ES_M.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_M.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_M.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES_M.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND ES_M.DATA_ID = 482
                                      AND ROWNUM = 1) AS CODIGO_CONVENIO
                                 ,(SELECT ES_AD.DATA_VALUE
                                     FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                    WHERE ES_AD.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND ES_AD.DATA_ID = 483
                                      AND ROWNUM <= 1) AS CODIGO_CONVENIADO
                                 ,NULL AS CODIGO_RESTRICAO
                                 ,ES_F.AUTHORIZER_ID AS USUARIO_AUTORIZOU
                                 ,(SELECT ES.INTEREST
                                     FROM EMPORIUM.EXPDET_SALE ES
                                    WHERE ES.STORE_KEY = ES_F.STORE_KEY
                                      AND ES.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND ES.SALE_TYPE <> 106) AS VALOR_JUROS
                                 ,NULL AS COMPROVANTE_NAO_FISCAL
                                 ,NULL AS CMC7_CHEQUE
                                 ,(SELECT ES_AD.DATA_VALUE
                                     FROM EMPORIUM.EXPDET_sale_media_data ES_AD
                                    WHERE ES_AD.DATA_ID = 17
                                      AND ES_AD.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND es_ad.sequence = es_f.sequence) AS CODIGO_BIN_TEF
                                 ,NULL AS TELEFONE_CLIENTE
                                 ,NULL AS PAGAMENTO_ACUMULADO
                                 ,NULL AS TIPO_ENTRADA
                                 ,NULL AS POSSIBILITA_ESTORNO
                                 ,NULL AS UTILIZACAO
                                 ,(SELECT ES_P_M.CUSTOMER_ID
                                     FROM EMPORIUM.EXPPICKUP_MEDIA_DATA ES_P_M
                                    WHERE ES_P_M.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_P_M.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_P_M.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND ES_P_M.SEQUENCE = ES_F.SEQUENCE
                                      AND ROWNUM <= 1
                                      AND TRUNC(ES_P_M.START_TIME) = TRUNC(ES_F.START_TIME)) AS RG_CLIENTE
                                 ,NULL AS RAMAL_CLIENTE
                                 ,NULL AS TIPO_TELEFONE
                                 ,(SELECT ES.POS_NUMBER
                                     FROM EXPDET_SALE ES
                                    WHERE ES.STORE_KEY = ES_F.STORE_KEY
                                      AND ES.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND ROWNUM <= 1
                                      AND ES.SALE_TYPE <> 106) AS NUMERO_CAIXA_OP
                                 ,ES_F.STORE_KEY AS NUMERO_LOJA_OP
                                 ,NULL AS NUMERO_OP
                                 ,NULL AS COTACAO_MOEDA_ESTRANGEIRA
                                 ,(SELECT ES_AD.DATA_VALUE
                                     FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                    WHERE ES_AD.DATA_ID = 71
                                      AND ES_AD.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND ROWNUM <= 1) AS MOTIVO_SANGRIA
                                 ,ES_F.SPLITS AS QTD_PARCELAS_TEF
                                 ,(SELECT ES_AD.DATA_VALUE
                                     FROM EMPORIUM.EXPDET_sale_media_data ES_AD
                                    WHERE ES_AD.DATA_ID = 96
                                      AND ES_AD.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND es_ad.sequence = es_f.sequence) AS CODIGO_BANDEIRA
                                 ,(SELECT ES_AD.DATA_VALUE
                                     FROM EMPORIUM.EXPDET_sale_media_data ES_AD
                                    WHERE ES_AD.DATA_ID = 18
                                      AND ES_AD.STORE_KEY = ES_F.STORE_KEY
                                      AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                      AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                      AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                      AND es_ad.sequence = es_f.sequence) AS CODIGO_ADMINISTRADORA
                                 ,CASE
                                     WHEN ES_F.MEDIA_ID = 6 THEN
                                      'C'
                                     ELSE
                                      CASE
                                         WHEN ES_F.MEDIA_ID = 7 THEN
                                          'D'
                                         ELSE
                                          CASE
                                             WHEN ES_F.MEDIA_ID = 8 THEN
                                              'T'
                                          END
                                      END
                                  END AS TIPO_CARTAO
                                 ,NULL AS OPERADOR_INFORM_ADM
                                 ,CASE
                                     WHEN ES_F.MEDIA_ID = 17 THEN
                                      (SELECT ES_AD.DATA_VALUE
                                         FROM EMPORIUM.EXPDET_sale_media_data ES_AD
                                        WHERE ES_AD.DATA_ID = 205
                                          AND ES_AD.STORE_KEY = ES_F.STORE_KEY
                                          AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                          AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                          AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                          AND es_ad.sequence = es_f.sequence)
                                     ELSE
                                      (SELECT ES_AD.DATA_VALUE
                                         FROM EMPORIUM.EXPDET_sale_media_data ES_AD
                                        WHERE ES_AD.DATA_ID = 62
                                          AND ES_AD.STORE_KEY = ES_F.STORE_KEY
                                          AND ES_AD.POS_NUMBER = ES_F.POS_NUMBER
                                          AND ES_AD.TICKET_NUMBER = ES_F.TICKET_NUMBER
                                          AND TRUNC(ES_AD.START_TIME) = TRUNC(ES_F.START_TIME)
                                          AND es_ad.sequence = es_f.sequence)
                                  END AS NUMERO_AUTORIZACAO
                           --NULL AS Valor_Doacao --FERNANDO
                             FROM EMPORIUM.EXPDET_SALE_MEDIA ES_F
                            WHERE (TRUNC(ES_F.START_TIME) >= TRUNC(R1.DATA_VENDA) AND TRUNC(ES_F.START_TIME) < TRUNC((R1.DATA_VENDA + 1)))
                              AND ES_F.STORE_KEY = R1.NUMERO_LOJA
                              AND ES_F.POS_NUMBER = R1.NUMERO_PDV
                              AND ES_F.TICKET_NUMBER = R1.NUMERO_CUPOM
                              AND ES_F.AMOUNT > 0
                              and ( (blnFinDaWeb = 1 and es_f.media_id = 9 and rownum = 1) or (blnFinDaWeb = 0) or (intContadorEcommerce = 1))
                            ORDER BY ES_F.SEQUENCE
                           )
                     LOOP
                        --Caso 43840 - Victor Lustosa - 25/05/2025
                        --CÓDIGO QUE SERÁ ALTERADO CODIGO_FINALIZADORA
                        --CRIAR UMA NOVA VARIÁVEL PARA RECEBER O VALOR DA r2_2.CODIGO_FINALIZADORA
                        intCodigoFinalizadora := r2_2.CODIGO_FINALIZADORA;

                        --Caso .... - Caio - 07/10/2025
                        blnFinalizadoraCartaoVirtual := FALSE;
                        IF intCodigoFinalizadora = VITRUVIO.FNC_CONFIG('ecxCodFinConecto') THEN
                           blnFinalizadoraCartaoVirtual := TRUE;
                           intCodigoFinalizadora        := VITRUVIO.FNC_CONFIG('ecxCodFinSuperus');
                        END IF;

                        IF r2_2.CODIGO_FINALIZADORA IN (1, 9)
                        AND blnFinDaWeb = 1
                        AND (
                                (intPreVenda > 0 AND intQtdeFinCupom = 0)
                                OR (parPedidoE > 0)
                            )
                        THEN
                           BEGIN
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                               
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1904, 'VERDEMAR.PEDIDOS_ECOMMERCE/VERDEMAR.TB_BDC_FIN_DAV');
                              FOR ecomm_ret IN (
                                 SELECT TIPO, SEQ, VAL
                                   FROM (SELECT 'PEDIDOSECOMMERCE' TIPO
                                               ,D.SEQ SEQ
                                               ,D.VAL
                                           FROM VERDEMAR.PEDIDOSECOMMERCE PE1
                                               ,VERDEMAR.TB_BDC_FIN_DAV D
                                          WHERE PE1.CHAVE_PEDIDO_SUPERUS = intPreVenda
                                            AND D.COD_DAV = PE1.CHAVE_PEDIDO_SUPERUS
                                            AND PE1.RETIRADA_LOJA = 1
                                            AND D.FIN = 9
                                         UNION ALL
                                         SELECT 'PEDIDOS_ECOMMERCE' TIPO
                                               ,D.SEQ SEQ
                                               ,D.VAL
                                           FROM VERDEMAR.PEDIDOS_ECOMMERCE PE2
                                               ,VERDEMAR.TB_BDC_FIN_DAV D
                                          WHERE PE2.PEDIDO_SUPERUS = intPreVenda
                                            AND D.COD_DAV = PE2.PEDIDO_SUPERUS
                                            AND PE2.ENTREGA = 0
                                            AND D.FIN = 9)
                                  WHERE VAL = r2_2.VALOR)
                              LOOP
                                 intCodigoFinalizadora := VITRUVIO.FNC_CONFIG('finalizadoraEcommerce');

                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                               
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1904, 'VERDEMAR.TB_ECOMMERCE_RETIRADA_CAPA');
                                 INSERT INTO VERDEMAR.TB_ECOMMERCE_RETIRADA_CAPA
                                    (CHAVE
                                    ,TIPO_ENTRADA
                                    ,LOJA
                                    ,DATA
                                    ,PDV
                                    ,CUPOM
                                    ,PEDIDO_SUPERUS
                                    ,status
                                    ,SEQUENCIA
                                    ,DATA_INC
                                    ,TOTAL
                                    ,FINALIZADORA_ORIGINAL)
                                 VALUES
                                    (verdemar.seq_ecommerce_retirada_capa.NEXTVAL
                                    ,ecomm_ret.TIPO
                                    ,intCodigoLoja
                                    ,r2_2.DATA_MOVIMENTO
                                    ,r2_2.NUMERO_PDV
                                    ,r2_2.NUMERO_CUPOM
                                    ,intPreVenda
                                    ,0
                                    ,r2_2.SEQUENCIA
                                    ,SYSDATE
                                    ,r2_2.VALOR
                                    ,R2_2.CODIGO_FINALIZADORA);
                              END LOOP;
                           END;
                        END IF;

                        -- Gabriel Fonseca = CASO: 37884 = Ajuste da mensagem de erro na tabela log de importação. INÍCIO
                        BEGIN
                           intCpfCnpjConv := TO_NUMBER(TRIM(REPLACE(REPLACE(REPLACE(r1.numero_cpf_cnpj, '.', ''), '-', ''), '/', '')));
                          EXCEPTION
                              when others then
                                   prc_raiseapplication('Problema ao converter CPF/CNPJ - VERIFIQUE NA TABELA EXPDET_ANSWER_DATA ' || '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                        END;
                        -- Gabriel Fonseca = CASO: 37884 = Ajuste da mensagem de erro na tabela log de importação. FIM

                        --VALIDA SE O CÓDIGO DA BANDEIRA É NUMÉRICO
                        BEGIN
                           intContador := NVL(SUBSTR(r2_2.CODIGO_BIN_TEF, 1, 6), 0);
                        EXCEPTION
                             WHEN OTHERS THEN
                                  PRC_RAISEAPPLICATION('Problema ao converter o código da bandeira para número - VERIFIQUE NA TABELA EXPDET_ANSWER_DATA COM O ID 17! '|| '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                        END;

                        fltTroco := r2_2.TROCO;
                        --DE ACORDO COM O FERNANDO, NÃO HÁ LIGAÇÃO DAS TABELAS, LOGO TEMOS QUE DEIXAR FIXO O VALOR DE
                        --DOAÇÃO SOMENTE PARA A FINALIZADORA DINHEIRO
                        --IF (r2_2.CODIGO_FINALIZADORA = 1 and fltValorDoacao = 0) THEN
                        --03/11/2023 -- Caio Guelre - Só pode aplicar doação quando existir troco
                        --Caso 43573 - Caio - 24/04/2025
                        BEGIN
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                               
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(1987, 'EMPORIUM.ANSWER_DATA');                        
                           SELECT TO_NUMBER(A.DATA_VALUE)
                             INTO intFinalizadoraDoacao
                             FROM EMPORIUM.ANSWER_DATA A
                            WHERE DATA_ID = 479 --FINALIZADORA DOAÇÃO
                              AND STORE_KEY = r2_2.NUMERO_LOJA
                              AND TRUNC(START_TIME) = r2_2.DATA_MOVIMENTO
                              AND POS_NUMBER = r2_2.NUMERO_PDV
                              AND TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                        EXCEPTION
                             WHEN OTHERS THEN
                                  intFinalizadoraDoacao := 0;
                        END;

                        --Verifica na tabela de complemento da finalizadora se pela sequência, é ela quem faz a doação
                        BEGIN
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                           
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2005, 'EMPORIUM.EXPDET_SALE_MEDIA_DATA');
                           SELECT COUNT(*)
                             INTO intContador
                             FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA ESM
                            WHERE ESM.DATA_ID = 481
                              AND ESM.STORE_KEY = r2_2.NUMERO_LOJA
                              AND TRUNC(ESM.START_TIME) = r2_2.DATA_MOVIMENTO
                              AND ESM.POS_NUMBER = r2_2.NUMERO_PDV
                              AND ESM.TICKET_NUMBER = r2_2.NUMERO_CUPOM
                              AND ESM.SEQUENCE = R2_2.SEQUENCIA_CONECTO;
                        EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                  intContador := 0;
                        END;

                        BEGIN
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                           
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2023, 'FINALIZADORAS');
                           SELECT F.TIPODOCUMENTO
                             INTO strTipoFinalizadora
                             FROM FINALIZADORAS F
                            WHERE F.FINALIZADORAFRENTE = intCodigoFinalizadora;
                        EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                  strTipoFinalizadora := '';
                        END;

                        --ENTRA SOMENTE SE A FINALIZADORA DO CUPOM É A MESMA DA DOAÇÃO
                        IF (intFinalizadoraDoacao = intCodigoFinalizadora AND intContador > 0) OR (strTipoFinalizadora = FINALIZADORAS_PKG.DINHEIRO) THEN
                           BEGIN
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2038, 'EMPORIUM.ANSWER_DATA');                           
                              SELECT TO_NUMBER(A.DATA_VALUE)
                                INTO fltValorDoacao
                                FROM EMPORIUM.ANSWER_DATA A
                               WHERE DATA_ID = 481 --DOAÇÃO
                                 AND STORE_KEY = r2_2.NUMERO_LOJA
                                 AND TRUNC(START_TIME) = r2_2.DATA_MOVIMENTO
                                 AND POS_NUMBER = r2_2.NUMERO_PDV
                                 AND TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                           EXCEPTION
                                WHEN OTHERS THEN
                                     fltValorDoacao := 0;
                           END;

                           IF fltValorDoacao > 0 AND strTipoFinalizadora <> FINALIZADORAS_PKG.DINHEIRO THEN
                              BEGIN
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2056, 'EMPORIUM.ANSWER_DATA');
                                 SELECT AD.DATA_VALUE
                                   INTO strCNPJInstituicao
                                   FROM EMPORIUM.ANSWER_DATA AD
                                  WHERE AD.DATA_ID = 480 --CNPJ
                                    AND AD.STORE_KEY = r2_2.NUMERO_LOJA
                                    AND TRUNC(AD.START_TIME) = r2_2.DATA_MOVIMENTO
                                    AND AD.POS_NUMBER = r2_2.NUMERO_PDV
                                    AND AD.TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                              EXCEPTION
                                   WHEN OTHERS THEN
                                        strCNPJInstituicao := NULL;
                              END;
                              IF LENGTH(NVL(strCNPJInstituicao,'-1')) <> 14 THEN
                                 fltValorDoacao := 0;
                              END IF;
                           END IF;

                           --Alterei para validar somente quando for dinheiro pelo tipo e não por código fixo
                           IF strTipoFinalizadora = FINALIZADORAS_PKG.DINHEIRO THEN
                              IF r2_2.TROCO = 0 THEN
                                 fltValorDoacao := 0;
                              END IF;
                           END IF;
                        END IF;

                        vNumero_Cpf_Cnpj := r2_2.numero_cpf_cnpj;
                        vDetalhe         := 'Data: ' || r2_2.data_movimento || ' - Loja: ' || R1.NUMERO_LOJA || ' - PDV: ' || r2_2.numero_pdv || ' - Cupom: ' || r2_2.numero_cupom || ' - Seq.: ' || r2_2.sequencia;
                        vCodigo          := 0;
                        vTipo            := '';
                        vData            := r2_2.DATA_MOVIMENTO;
                        vPDV             := r2_2.numero_pdv;
                        vCupom           := r2_2.numero_cupom;
                        vVencimento := case
                                          when r2_2.data_deposito is null Then
                                           r2_2.data_movimento
                                          else
                                           r2_2.data_deposito
                                       end;
                        if intCodigoFinalizadora = 15 then
                           /* Socio torcedor - inicio */
                           begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2100, 'EMPORIUM.EXPDET_SALE_DISCOUNT');
                              select sum(m.amount)
                                into fltSoma
                                from EMPORIUM.EXPDET_SALE_DISCOUNT m
                               where TRUNC(m.start_time) = TRUNC(r2_2.DATA_MOVIMENTO)
                                 and m.pos_number = r2_2.numero_pdv
                                 and m.ticket_number = r2_2.numero_cupom
                                 and m.store_key = r2_2.numero_loja
                                 and m.type = 23;
                           exception
                              when no_data_found then
                                 fltSoma := 0;
                           end;
                           if fltSoma = r2_2.valor then
                              vCPF_CNPJ_SocioTorcedor := r2_2.numero_cpf_cnpj;
                              If intNovaTabelaDesconto = 0 Then
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2118, 'socin_detalhes_cupom_desconto');
                                 insert into socin_detalhes_cupom_desconto
                                    (select TRUNC(m.start_time) AS data_movimento
                                           ,store_key AS intCodigoLoja
                                           ,pos_number AS numero_pdv
                                           ,ticket_number AS numero_cupom
                                           ,(sequence + 1) AS sequencia
                                           ,m.type tip_dsc
                                           ,0
                                           ,0
                                           ,m.amount
                                           ,0 sit_int
                                           ,CASE
                                               WHEN (SELECT ES_S.SALE_TYPE
                                                       FROM EMPORIUM.EXPDET_SALE ES_S
                                                      WHERE ES_S.STORE_KEY = m.STORE_KEY
                                                        AND ES_S.POS_NUMBER = m.POS_NUMBER
                                                        AND ES_S.TICKET_NUMBER = m.TICKET_NUMBER
                                                        AND TRUNC(ES_S.START_TIME) = TRUNC(m.START_TIME)) = 32 THEN
                                                'ERRO'
                                               ELSE
                                                ''
                                            END AS mtv_err_int
                                           ,(SELECT ES_AD.DATA_VALUE
                                               FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                              WHERE ES_AD.DATA_ID = 191
                                                AND ES_AD.STORE_KEY = m.STORE_KEY
                                                AND ES_AD.POS_NUMBER = m.POS_NUMBER
                                                AND ES_AD.TICKET_NUMBER = m.TICKET_NUMBER
                                                AND TRUNC(ES_AD.START_TIME) = TRUNC(m.START_TIME)) AS vCPF_CNPJ_SocioTorcedor
                                           ,r1.Codigo_Operador
                                           ,0
                                       from EMPORIUM.EXPDET_SALE_DISCOUNT m
                                      where TRUNC(m.start_time) = TRUNC(r2_2.DATA_MOVIMENTO)
                                        and m.pos_number = r2_2.numero_pdv
                                        and m.ticket_number = r2_2.numero_cupom
                                        and m.store_key = r2_2.numero_loja
                                        and m.type = 10
                                     --and m.tipo_promocao <> 9
                                     );
                              Else
                                 insert into socin_detalhes_cupom_desconto
                                    (select TRUNC(m.start_time) AS data_movimento
                                           ,m.store_key intCodigoLoja
                                           ,m.pos_number num_pdv
                                           ,m.ticket_number num_cup
                                           ,m.sequence seq
                                           ,m.type tip_dsc
                                           ,0
                                           ,0
                                           ,m.amount
                                           ,0 sit_int
                                           ,CASE
                                               WHEN (SELECT ES_S.SALE_TYPE
                                                       FROM EMPORIUM.EXPDET_SALE ES_S
                                                      WHERE ES_S.STORE_KEY = m.STORE_KEY
                                                        AND ES_S.POS_NUMBER = m.POS_NUMBER
                                                        AND ES_S.TICKET_NUMBER = m.TICKET_NUMBER
                                                        AND TRUNC(ES_S.START_TIME) = TRUNC(m.START_TIME)) = 32 THEN
                                                'ERRO'
                                               ELSE
                                                ''
                                            END AS mtv_err_int
                                           ,(SELECT ES_AD.DATA_VALUE
                                               FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                              WHERE ES_AD.DATA_ID = 491
                                                AND ES_AD.STORE_KEY = m.STORE_KEY
                                                AND ES_AD.POS_NUMBER = m.POS_NUMBER
                                                AND ES_AD.TICKET_NUMBER = m.TICKET_NUMBER
                                                AND TRUNC(ES_AD.START_TIME) = TRUNC(m.START_TIME)) AS vCPF_CNPJ_SocioTorcedor
                                           ,r1.Codigo_Operador
                                           ,0
                                       from EMPORIUM.EXPDET_SALE_DISCOUNT m
                                      where TRUNC(m.start_time) = TRUNC(r2_2.DATA_MOVIMENTO)
                                        and m.pos_number = r2_2.numero_pdv
                                        and m.ticket_number = r2_2.numero_cupom
                                        and m.store_key = r2_2.numero_loja
                                        and m.type = 23);
                              End If;
                              select count(*)
                                into vCont
                                from (select sd.codigo
                                            ,(select adm.codigo
                                                from produtos_loja  plj
                                                    ,administradora adm
                                               where plj.codigo = sd.codigo
                                                 and plj.loja = 17
                                                 and plj.fornecedor = adm.codigo) as fornecedor_adm
                                        from socin_detalhes_cupom_desconto sdd
                                            ,socin_detalhes_cupom          sd
                                       where 1 = 1
                                         and sdd.sequencia = sd.sequencia
                                         and sdd.data = sd.data
                                         and sdd.loja = sd.loja
                                         and sdd.pdv = sd.pdv
                                         and sdd.cupom = sd.cupom
                                         and sd.DATA = r2_2.data_movimento
                                         and sd.LOJA = intCodigoLoja
                                         and sd.PDV = r2_2.numero_pdv
                                         and sd.CUPOM = r2_2.numero_cupom) T1
                               where t1.fornecedor_adm is null;
                              if vCont > 0 then
                                 /*Validacao Adminstradora para o Fornecedor cadastrada*/
                                 vTotalFinalizadora := 0;
                                 strMsmErroAdiciona := ' Erro Adm n o cadastrada. Socio Torcedor ';
                              end if;
                           else
                              vTotalFinalizadora := 0;
                              strMsmErroAdiciona := ' Erro CPF n o informado. Socio Torcedor ';
                           end if;
                           /*else
                           vTotalFinalizadora := 0;
                           strMsmErroAdiciona := ' Erro Vlr Desc. Socio Torcedor '; */
                        end if;
                        /*Insere valor do desconto concedidos pelo Cartao Fidelidade -- inicio */
                        blnDescontoFidelidadeInserido := true;
                        If intNovaTabelaDesconto = 0 Then
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2237, 'socin_detalhes_cupom_desconto');
                           insert into socin_detalhes_cupom_desconto
                              (select TRUNC(start_time) AS data_movimento
                                     ,store_key intCodigoLoja
                                     ,pos_number num_pdv
                                     ,ticket_number num_cup
                                     ,sequence seq
                                     ,type tip_dsc
                                     ,0
                                     ,0
                                     ,amount vlr_dsc
                                     ,0 sit_int
                                     ,CASE
                                         WHEN (SELECT ES_S.SALE_TYPE
                                                 FROM EMPORIUM.EXPDET_SALE ES_S
                                                WHERE ES_S.STORE_KEY = m.STORE_KEY
                                                  AND ES_S.POS_NUMBER = m.POS_NUMBER
                                                  AND ES_S.TICKET_NUMBER = m.TICKET_NUMBER
                                                  AND TRUNC(ES_S.START_TIME) = TRUNC(m.START_TIME)) = 32 THEN
                                          'ERRO'
                                         ELSE
                                          ''
                                      END AS mtv_err_int
                                     ,vCPF_CNPJ_SocioTorcedor
                                     ,r1.Codigo_Operador
                                     ,0
                                 from EMPORIUM.EXPDET_SALE_DISCOUNT m
                                where TRUNC(m.start_time) = TRUNC(r2_2.DATA_MOVIMENTO)
                                  and m.pos_number = r2_2.numero_pdv
                                  and m.ticket_number = r2_2.numero_cupom
                                  and m.store_key = r2_2.numero_loja
                                  and m.type = 6);
                        End If;
                        /*Insere valor do desconto concedidos pelo Cartao Fidelidade -- fim */
                        /*Danilo Caso 4858 - Socio torcedor - fim*/
                        vQtd_Parcelas_TEF  := r2_2.qtd_parcelas_tef;
                        vNumeroAutorizacao := r2_2.numero_autorizacao;
                        If NVL(vNumeroAutorizacao, '0') = '0' then
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2237, 'EMPORIUM.EXPDET_SALE_MEDIA_DATA');
                              SELECT SI.DATA_VALUE
                                INTO vCodRoteador
                                FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA SI
                               WHERE (TRUNC(SI.START_TIME) >= TRUNC(R2_2.DATA_MOVIMENTO) AND TRUNC(SI.START_TIME) <= TRUNC(R2_2.DATA_MOVIMENTO))
                                 AND SI.STORE_KEY = R2_2.NUMERO_LOJA
                                 AND SI.POS_NUMBER = R2_2.NUMERO_PDV
                                 AND SI.TICKET_NUMBER = R2_2.NUMERO_CUPOM
                                 AND SI.SEQUENCE = R2_2.SEQUENCIA - 1
                                 AND SI.DATA_ID = 18; -- 226; -- GABRIEL FONSECA 22/10/25 - CASO 44958 - AJUSTE PARA GRAVAR ROTEADOR EM CASO DE PAGAMENTO COM DOIS CARTÕES
                           exception
                              when no_data_found then
                                 vCodRoteador := NULL;
                           End;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2295, 'EMPORIUM.EXPDET_SALE_MEDIA_DATA');
                              SELECT SI.DATA_VALUE
                                INTO strNSU
                                FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA SI
                               WHERE (TRUNC(SI.START_TIME) >= TRUNC(R2_2.DATA_MOVIMENTO) AND TRUNC(SI.START_TIME) <= TRUNC(R2_2.DATA_MOVIMENTO))
                                 AND SI.STORE_KEY = R2_2.NUMERO_LOJA
                                 AND SI.POS_NUMBER = R2_2.NUMERO_PDV
                                 AND SI.TICKET_NUMBER = R2_2.NUMERO_CUPOM
                                 AND SI.SEQUENCE = R2_2.SEQUENCIA - 1
                                 AND SI.DATA_ID = 203;
                           exception
                              when no_data_found then
                                 strNSU := NULL;
                           end;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2312, 'EMPORIUM.EXPDET_SALE_MEDIA_DATA');
                              SELECT SI.DATA_VALUE
                                INTO vNsu_host
                                FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA SI
                               WHERE (TRUNC(SI.START_TIME) >= TRUNC(R2_2.DATA_MOVIMENTO) AND TRUNC(SI.START_TIME) <= TRUNC(R2_2.DATA_MOVIMENTO))
                                 AND SI.STORE_KEY = R2_2.NUMERO_LOJA
                                 AND SI.POS_NUMBER = R2_2.NUMERO_PDV
                                 AND SI.TICKET_NUMBER = R2_2.NUMERO_CUPOM
                                 AND SI.SEQUENCE = R2_2.SEQUENCIA - 1
                                 AND SI.DATA_ID = 204;
                           exception
                              when no_data_found then
                                 vNsu_host := null;
                           end;
                        Else
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2330, 'EMPORIUM.EXPDET_SALE_MEDIA_DATA');
                              SELECT SI.DATA_VALUE
                                INTO vCodRoteador
                                FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA SI
                               WHERE (TRUNC(SI.START_TIME) >= TRUNC(R2_2.DATA_MOVIMENTO) AND TRUNC(SI.START_TIME) <= TRUNC(R2_2.DATA_MOVIMENTO))
                                 AND SI.STORE_KEY = R2_2.NUMERO_LOJA
                                 AND SI.POS_NUMBER = R2_2.NUMERO_PDV
                                 AND SI.TICKET_NUMBER = R2_2.NUMERO_CUPOM
                                 AND SI.SEQUENCE = R2_2.SEQUENCIA - 1
                                 AND SI.DATA_ID = 18; -- 226; -- GABRIEL FONSECA 22/10/25 - CASO 44958 - AJUSTE PARA GRAVAR ROTEADOR EM CASO DE PAGAMENTO COM DOIS CARTÕES
                           exception
                              when no_data_found then
                                 vCodRoteador := NULL;
                           End;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2347, 'EMPORIUM.EXPDET_SALE_MEDIA_DATA');
                              SELECT SI.DATA_VALUE
                                INTO strNSU
                                FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA SI
                               WHERE (TRUNC(SI.START_TIME) >= TRUNC(R2_2.DATA_MOVIMENTO) AND TRUNC(SI.START_TIME) <= TRUNC(R2_2.DATA_MOVIMENTO))
                                 AND SI.STORE_KEY = R2_2.NUMERO_LOJA
                                 AND SI.POS_NUMBER = R2_2.NUMERO_PDV
                                 AND SI.TICKET_NUMBER = R2_2.NUMERO_CUPOM
                                 AND SI.SEQUENCE = R2_2.SEQUENCIA - 1
                                 AND SI.DATA_ID = 203;
                           exception
                              when no_data_found then
                                 strNSU := NULL;
                           end;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                             
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2364, 'EMPORIUM.EXPDET_SALE_MEDIA_DATA');
                              SELECT SI.DATA_VALUE
                                INTO vNsu_host
                                FROM EMPORIUM.EXPDET_SALE_MEDIA_DATA SI
                               WHERE (TRUNC(SI.START_TIME) >= TRUNC(R2_2.DATA_MOVIMENTO) AND TRUNC(SI.START_TIME) <= TRUNC(R2_2.DATA_MOVIMENTO))
                                 AND SI.STORE_KEY = R2_2.NUMERO_LOJA
                                 AND SI.POS_NUMBER = R2_2.NUMERO_PDV
                                 AND SI.TICKET_NUMBER = R2_2.NUMERO_CUPOM
                                 AND SI.SEQUENCE = R2_2.SEQUENCIA - 1
                                 AND SI.DATA_ID = 204;
                           exception
                              when no_data_found then
                                 vNsu_host := null;
                           end;
                        End If;
                        vfinalizadorafrente         := intCodigoFinalizadora;
                        bkpvNumeroAutorizacao       := vNumeroAutorizacao;
                        TrocaPixEcommerce           := 0;
                        blnUtilizouDivergenciaEcomm := false;
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                             
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2385, 'PEDIDOS_ECOMMERCE/PEDIDOS/finalizadoras');
                        select count(*) as Contador
                              ,sum(valor) as TotalFinalizadoraEcommmerce
                          into intContador
                              ,fltTotalFinalizadoraEcommmerce
                          from (SELECT fin.finalizadorafrente
                                      ,REPLACE(PG.PAYMENTID, '-', '') NUMERO_AUTORIZACAO
                                      ,sum(nvl(pv.valor, ped.valor)) as valor
                                  FROM PEDIDOS_ECOMMERCE            P
                                      ,PEDIDOS_ECOMMERCE_PAGAMENTOS PG
                                      , --DANIEL SENRA 26/09/22
                                       pedidos                      ped
                                      ,condicoes_pagamento          condpgt
                                      ,finalizadoras                fin
                                      ,pedidos_vencimentos          pv
                                 WHERE (CASE
                                          WHEN intRestaurante = 1 THEN
                                           P.PEDIDO_SUPERUS_RESTAURANTE --9400330 --intPreVenda
                                          ELSE
                                           P.PEDIDO_SUPERUS
                                       END) = intPreVenda
                                   AND PG.CHAVEPEDIDO(+) = P.CHAVE --DANIEL SENRA 26/09/22
                                   and P.PEDIDO_SUPERUS = ped.chave
                                   and condpgt.codigo = ped.condicaopagamento
                                   and condpgt.finalizadora = fin.codigo
                                   AND P.STATUS = 'S'
                                   and pv.chavepedido(+) = ped.chave
                                 group by fin.finalizadorafrente
                                         ,REPLACE(PG.PAYMENTID, '-', '')
                                union
                                SELECT e.finalizadorafrente
                                      ,REPLACE(b.TID, '-', '') NUMERO_AUTORIZACAO
                                      ,decode(d.codigo, 671, pe1.valor_desconto, 0) + a.valor as valor /*Feito por danilo em 19/05/2022 - alinhado sobre o codigo fixo, necessario no momento ate que seja entendio o processo e criado um conceito  caso 0029511*/
                                --                                      a.valor
                                  FROM pedidospagamentosecommerce A
                                 inner join PEDIDOSECOMMERCE pe1
                                    on pe1.id = a.pedido_id
                                  left join pedidosdetpagamentosecommerce B
                                    on A.ID = B.PAGAMENTO_ID
                                 inner join pedidosdetfaturamentoecommerce C
                                    on A.ID = C.PAGAMENTO_ID
                                 inner join CONDICOES_PAGAMENTO D
                                    on d.codigo = c.valor
                                 inner join finalizadoras e
                                    on e.codigo = d.finalizadora
                                 WHERE pe1.chave_pedido_superus = intPreVenda --9400330 --1139926
                                union
                                SELECT 5                  as finalizadorafrente
                                      , /* troca */null               NUMERO_AUTORIZACAO
                                      ,pe1.valor_desconto
                                  FROM pedidospagamentosecommerce A
                                 inner join PEDIDOSECOMMERCE pe1
                                    on pe1.id = a.pedido_id
                                  left join pedidosdetpagamentosecommerce B
                                    on A.ID = B.PAGAMENTO_ID
                                 inner join pedidosdetfaturamentoecommerce C
                                    on A.ID = C.PAGAMENTO_ID
                                 inner join CONDICOES_PAGAMENTO D
                                    on d.codigo = c.valor
                                 inner join finalizadoras e
                                    on e.codigo = d.finalizadora
                                 inner join pedidos ped
                                    on ped.chave = pe1.chave_pedido_superus
                                 WHERE pe1.chave_pedido_superus = intPreVenda --9400330 --1139926
                                   and (pe1.valor_desconto - ped.descontototalitem) > 0 -- Lazaro - 18/08/2022
                                   and d.codigo <> 671 /*Feito por danilo em 19/05/2022 - alinhado sobre o codigo fixo, necessario no momento ate que seja entendio o processo e criado um conceito caso 0029511*/
                                --and not exists (select 1 from log_cupomdecredito_promocional where idpedido = intPreVenda)
                                );
                        /*  select valor
                          from log_cupomdecredito_promocional
                         where idpedido = 9260915
                        */
                        if ((r2_2.NUMERO_CUPOM in (60226, 60228)) and (r2_2.NUMERO_PDV = 166) and (r2_2.NUMERO_LOJA = 10)) then
                           intContador := 0; -- Danilo processo 34691 - 16/02/2024
                        end if;

                        /*processo 28747 rotina duplicada para tratar importacao de cumpo finalizado com 1 finalizadora porem a compra foi feita por 2 ou amis nfinalizadoras no ecommerce*/
                        if (nvl(intPreVenda, 0) > 0) and (intCodigoFinalizadora = 9) and intContador > 0 then
                           TrocaPixEcommerce := 1;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                               
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2467, 'SOCIN_FINALIZADORAS');
                              SELECT MAX(SF.SEQUENCIA)
                                INTO intSequencia
                                FROM SOCIN_FINALIZADORAS SF
                               WHERE SF.DATA = r2_2.DATA_MOVIMENTO
                                 AND SF.LOJA = FNC_CODIGOLOJA(r2_2.NUMERO_LOJA)
                                 AND SF.PDV = r2_2.NUMERO_PDV
                                 AND SF.CUPOM = r2_2.NUMERO_CUPOM;
                           Exception
                              when others then
                                 intSequencia := 0;
                           End;
                           if intSequencia is null then
                              intSequencia := 0;
                           End If;
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                          
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2484, 'PEDIDOS_ECOMMERCE/PEDIDOS/finalizadoras');
                           for ftmp in (SELECT fin.finalizadorafrente
                                              ,REPLACE(PG.PAYMENTID, '-', '') NUMERO_AUTORIZACAO
                                              ,sum(nvl(pv.valor, ped.valor)) as valor
                                              ,'V' ORIGEM_PEDIDO
                                          FROM PEDIDOS_ECOMMERCE            P
                                              ,PEDIDOS_ECOMMERCE_PAGAMENTOS PG
                                              ,pedidos                      ped
                                              ,condicoes_pagamento          condpgt
                                              ,finalizadoras                fin
                                              ,pedidos_vencimentos          pv
                                         WHERE (CASE
                                                  WHEN intRestaurante = 1 THEN
                                                   P.PEDIDO_SUPERUS_RESTAURANTE --9400330 --intPreVenda
                                                  ELSE
                                                   P.PEDIDO_SUPERUS
                                               END) = intPreVenda
                                           AND PG.CHAVEPEDIDO(+) = P.CHAVE
                                           and P.PEDIDO_SUPERUS = ped.chave
                                           and condpgt.codigo = ped.condicaopagamento
                                           and condpgt.finalizadora = fin.codigo
                                           AND P.STATUS = 'S'
                                           and pv.chavepedido(+) = ped.chave
                                         group by fin.finalizadorafrente
                                                 ,REPLACE(PG.PAYMENTID, '-', '')
                                        union
                                        SELECT case
                                                  when upper(pe1.tipo_pedido) <> 'COMPRA' THEN
                                                   5
                                                  ELSE
                                                   e.finalizadorafrente
                                               END finalizadorafrente
                                              , --e.finalizadorafrente,
                                               REPLACE(b.TID, '-', '') NUMERO_AUTORIZACAO
                                              ,decode(d.codigo, 671, pe1.valor_desconto, 0) + a.valor as valor
                                              , /*Feito por danilo em 19/05/2022 - alinhado sobre o codigo fixo, necessario no momento ate que seja entendio o processo e criado um conceito  caso 0029511*/
                                               --                                      a.valor,
                                               pe1.origem_pedido
                                          FROM pedidospagamentosecommerce A
                                         inner join PEDIDOSECOMMERCE pe1
                                            on pe1.id = a.pedido_id
                                          left join pedidosdetpagamentosecommerce B
                                            on A.ID = B.PAGAMENTO_ID
                                         inner join pedidosdetfaturamentoecommerce C
                                            on A.ID = C.PAGAMENTO_ID
                                         inner join CONDICOES_PAGAMENTO D
                                            on d.codigo = c.valor
                                         inner join finalizadoras e
                                            on e.codigo = d.finalizadora
                                         WHERE pe1.chave_pedido_superus = intPreVenda --9400330 --1139926
                                        union
                                        SELECT 5                  as finalizadorafrente
                                              , /* troca */null               NUMERO_AUTORIZACAO
                                              ,pe1.valor_desconto
                                              ,pe1.origem_pedido
                                          FROM pedidospagamentosecommerce A
                                         inner join PEDIDOSECOMMERCE pe1
                                            on pe1.id = a.pedido_id
                                          left join pedidosdetpagamentosecommerce B
                                            on A.ID = B.PAGAMENTO_ID
                                         inner join pedidosdetfaturamentoecommerce C
                                            on A.ID = C.PAGAMENTO_ID
                                         inner join CONDICOES_PAGAMENTO D
                                            on d.codigo = c.valor
                                         inner join finalizadoras e
                                            on e.codigo = d.finalizadora
                                         inner join pedidos ped
                                            on ped.chave = pe1.chave_pedido_superus
                                         WHERE pe1.chave_pedido_superus = intPreVenda --9400330 --1139926
                                           and (pe1.valor_desconto - ped.descontototalitem) > 0 -- Lazaro - 18/08/2022
                                           and d.codigo <> 671 /*Feito por danilo em 19/05/2022 - alinhado sobre o codigo fixo, necessario no momento ate que seja entendio o processo e criado um conceito caso 0029511*/
                                        --and not exists (select 1 from log_cupomdecredito_promocional where idpedido = intPreVenda)
                                        )
                           loop
                              fltTmpValor         := ftmp.valor;
                              intSequencia        := intSequencia + 1;
                              vNumeroAutorizacao  := ftmp.numero_autorizacao;
                              vfinalizadorafrente := ftmp.finalizadorafrente;
                              begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                          
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2565, 'finalizadoras');
                                 select f.gravartickets into vGravarTicktes from finalizadoras f where f.finalizadorafrente = ftmp.finalizadorafrente;
                              exception
                                 when no_data_found then
                                    vCodFinalizadora := 0;
                              end;
                              if vGravarTicktes = 'S' then
                                 vfinalizadorafrente         := intCodigoFinalizadora;
                                 blnUtilizouDivergenciaEcomm := true; --colocado para nao rodar a rotina
                                 if ((vTotalCapa <> fltTotalFinalizadoraEcommmerce) and (abs(vTotalCapa - fltTotalFinalizadoraEcommmerce) <= 0.05) and (not blnUtilizouDivergenciaEcomm)) then
                                    blnUtilizouDivergenciaEcomm := true;
                                    fltTmpValor                 := fltTmpValor + (vTotalCapa - fltTotalFinalizadoraEcommmerce);
                                 end if;
                              end if;
                              IF intPreVenda IN (13314374,13314531,13314571,13314629,13314726,13314728,13314790,13314843,13314847,13314838,13314858,13314881,13314988,13314989,13314975,13314977,13314479,13314598,13314844,13314829,13314928,13314507,13314508,13314792,13314976,13314716,13314936,13314478,13314805,13314791,13314890,13314893,13314929,13315911,13315465,13315520,13315521,13315660,13315661,13315735,13315849,13315947,13314724,13314796,13315639,13315689,13315691,13315820,13315672,13315910,13315926,13315945,13315758,13315683,13315909,13315891,13315853) THEN
                                 fltTmpValor := vTotalCapa;
                              END IF;
                              if (vfinalizadorafrente = 17 and trim(vNumeroAutorizacao) is null) and ftmp.origem_pedido <> 'M' then
                                 prc_raiseapplication('Ecommerce finalizado com PIX porem sem TXID informado. Corrigir os dados do pedido no Ecommerce! '|| '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                              end if;
                              -- Henrique - Caso Substituição Cancelamento - Se for cancelado procura um processado e vice-versa. Segue abaixo: - 06/02/2024
                              if (vfinalizadorafrente = 17 and trim(vNumeroAutorizacao) is not null) and r1.voided = 0 then
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2590, 'socin_finalizadoras');
                                    select count(*)
                                      into intcontapixduplicado
                                      from socin_finalizadoras f
                                     where f.finalizadora = 17
                                       and f.data >= sysdate - 15
                                       and upper(f.numero_autorizacao) = UPPER(vnumeroautorizacao)
                                       AND NOT EXISTS (SELECT 1
                                              FROM SOCIN_CAPA_CUPOM CP
                                             INNER JOIN SOCIN_FINALIZADORAS SF
                                                ON CP.LOJA = SF.LOJA
                                               AND CP.DATA = SF.DATA
                                               AND CP.PDV = SF.PDV
                                               AND CP.CUPOM = SF.CUPOM
                                               AND CP.SITUACAO = 'C'
                                             WHERE CP.LOJA = F.LOJA
                                               AND CP.DATA = F.DATA
                                               AND upper(SF.NUMERO_AUTORIZACAO) = UPPER(vnumeroautorizacao));
                                 End;
                              end if;
                              if (vfinalizadorafrente = 17 and trim(vNumeroAutorizacao) is not null and r1.voided = 1) then
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                         
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2614, 'socin_finalizadoras');
                                    select count(*)
                                      into intcontapixduplicado
                                      from socin_finalizadoras f
                                     where f.finalizadora = 17
                                       and f.data >= sysdate - 15
                                       and upper(f.numero_autorizacao) = UPPER(vnumeroautorizacao)
                                       AND NOT EXISTS (SELECT 1
                                              FROM SOCIN_CAPA_CUPOM CP
                                             INNER JOIN SOCIN_FINALIZADORAS SF
                                                ON CP.LOJA = SF.LOJA
                                               AND CP.DATA = SF.DATA
                                               AND CP.PDV = SF.PDV
                                               AND CP.CUPOM = SF.CUPOM
                                               AND CP.SITUACAO = 'P'
                                             WHERE CP.LOJA = F.LOJA
                                               AND CP.DATA = F.DATA
                                               AND upper(SF.NUMERO_AUTORIZACAO) = UPPER(vnumeroautorizacao));
                                 End;
                              end if;
                              if (intcontapixduplicado > 0) then
                                 prc_raiseapplication('Ja existe um cupom com mesmo TXID: ' || vNumeroAutorizacao ||
                                                      ' ja importado! usar select: select * from socin_finalizadoras f where f.finalizadora = 17  and f.data >= sysdate-15 and upper(f.numero_autorizacao) = XXX' || '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                              end if;
                              Begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                               
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2641, 'finalizadoras');
                                 select Codigo
                                       ,fiado
                                       ,contasreceber
                                       ,chequesreceber
                                       ,cartaoproprio
                                       ,GRAVARTICKETS
                                   into vCodFinalizadora
                                       ,vFiado
                                       ,vContasReceber
                                       ,vChequesReceber
                                       ,vCartaoProprio
                                       ,vGravarTicktes
                                   from finalizadoras
                                  where finalizadorafrente = vfinalizadorafrente; -- r2.codigo_finalizadora;
                              Exception
                                 when no_data_found Then
                                    vFiado           := 'N';
                                    vContasReceber   := 'N';
                                    vChequesReceber  := 'N';
                                    vCartaoProprio   := 'N';
                                    vGravarTicktes   := 'N';
                                    vCodFinalizadora := 0;
                              End;
                              -- Caso 22078 - Lazrao - 25/01/2019
                              if (vCodFinalizadora = 0) Then
                                 prc_raiseapplication('Codigo da Finalizadora n?o encontrado. Entre em contato com o Suporte!' || ' - Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                              End If;

                              BEGIN
                                 vCodigoConvenio := r2_2.codigo_convenio;
                              EXCEPTION
                                 WHEN OTHERS THEN
                                    vCodigoConvenio := 0;
                              END;
                              --vCodigoConvenio := r2_2.codigo_convenio;
                              vCodigoEmpresa  := r2_2.codigo_conveniado;
                              if ftmp.origem_pedido = 'M' then
                                 vCodigoEmpresa  := '1362808';
                                 vCodigoConvenio := 500760;
                              end if;
                              Begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2685, 'clientes');
                                 select count(Codigo)
                                   into vCodigo
                                   from clientes
                                  where codigoconvenio = vCodigoConvenio
                                    and CODIGOEMPRESA = vCodigoEmpresa;
                                 If vCodigo = 1 Then
                                    select Codigo
                                      into vCodigo
                                      from clientes
                                     where codigoconvenio = vCodigoConvenio
                                       and CODIGOEMPRESA = vCodigoEmpresa;
                                 Else
                                    vCodigo := 0;
                                 End If;
                              Exception
                                 when no_data_found Then
                                    vCodigo := 0;
                              End;
                              --Lazaro Vencimento do Cliente
                              If vCodigo <> 0 Then
                                 Vencimento_cliente(vCodigo, r2_2.data_movimento, vVencimento);
                              End If;
                              If vFiado = 'S' Then
                                 vTipo := 'R';
                              ElsIf (vChequesReceber = 'S') or (vContasReceber = 'S') Then
                                 If (vChequesReceber = 'S') then
                                    vTipo := 'C';
                                 End If;
                                 if (vContasReceber = 'S') then
                                    vTipo := 'B';
                                 End If;
                                 If Length(r2_2.numero_cpf_cnpj) <= 7 then
                                    /*Caio  - Incio 89397*/
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                               
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2722, 'pessoas');
                                       select count(codigo) into vCont from pessoas where codigo = lpad(r2_2.numero_cpf_cnpj, 7, 0);
                                    Exception
                                       when no_data_found then
                                          vCont := 0;
                                    End;
                                    if vCont > 1 then
                                       Begin
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                              
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2732, 'pessoas');
                                          select codigo
                                            into vCodigo
                                            from pessoas
                                           where codigo = lpad(r2_2.numero_cpf_cnpj, 7, 0)
                                             and cliente = 'S'
                                             and rownum = 1;
                                       Exception
                                          when no_data_found then
                                             vCodigo := vCliCheq;
                                       end;
                                    else
                                       Begin
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2747, 'pessoas');
                                          select codigo into vCodigo from pessoas where codigo = lpad(r2_2.numero_cpf_cnpj, 7, 0);
                                       Exception
                                          when no_data_found then
                                             vCodigo := vCliCheq;
                                       End;
                                    End If;
                                 End If; /*Caio  - Fim 89397*/
                                 If Length(r2_2.numero_cpf_cnpj) >= 7 and Length(r2_2.numero_cpf_cnpj) <= 11 Then
                                    /*Caio  - 89397*/
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2760, 'pessoas');
                                       select count(codigo) into vCont from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '')) = lpad(r2_2.numero_cpf_cnpj, 11, 0);
                                    Exception
                                       when no_data_found then
                                          vCont := 0;
                                    end;
                                    if vCont > 1 then
                                       Begin
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2770, 'pessoas');
                                          select codigo
                                            into vCodigo
                                            from pessoas
                                           where TRIM(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '')) = lpad(r2_2.numero_cpf_cnpj, 11, 0)
                                             and cliente = 'S'
                                             and rownum = 1;
                                       Exception
                                          when no_data_found then
                                             vCodigo := vCliCheq;
                                       end;
                                    else
                                       Begin
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2785, 'pessoas');
                                          select codigo into vCodigo from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '')) = lpad(r2_2.numero_cpf_cnpj, 11, 0);
                                       Exception
                                          when no_data_found then
                                             vCodigo := vCliCheq;
                                       End;
                                    End If;
                                 End If;
                                 If Length(r2_2.numero_cpf_cnpj) > 11 Then
                                    /*Caio  - 89397*/
                                    Begin
                                       --Alterado para tratar o CNPJ maior que 14 digitos - Lazaro - 04-06-2008
                                       If Length(r2_2.numero_cpf_cnpj) = 16 Then
                                          vCNPJ := Substr(r2_2.numero_cpf_cnpj, 3, 14);
                                       ElsIf Length(r2_2.numero_cpf_cnpj) = 15 Then
                                          vCNPJ := Substr(r2_2.numero_cpf_cnpj, 2, 14);
                                       Else
                                          vCNPJ := r2_2.numero_cpf_cnpj;
                                       End If;
                                       vCNPJ := lpad(vCNPJ, 14, 0);
                                       Begin
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                              
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2808, 'pessoas');
                                          select count(codigo) into vCont from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '')) = vCNPJ;
                                       Exception
                                          when no_data_found then
                                             vCont := 0;
                                       End;
                                       if vCont > 1 then
                                          Begin
                                             /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                              
                                             PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                             PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2818, 'pessoas');
                                             select codigo
                                               into vCodigo
                                               from pessoas
                                              where TRIM(REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '')) = vCNPJ
                                                and cliente = 'S'
                                                and rownum = 1;
                                          Exception
                                             when no_data_found then
                                                vCodigo := vCliCheq;
                                          End;
                                       else
                                          Begin
                                             /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                             PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                             PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2833, 'pessoas');                                          
                                             select codigo into vCodigo from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '')) = vCNPJ;
                                          Exception
                                             when no_data_found then
                                                vCodigo := vCliCheq;
                                          End;
                                       End if;
                                    End;
                                 Else
                                    vCNPJ := r2_2.numero_cpf_cnpj;
                                 End If;
                                 If vCodigo = 0 Then
                                    vCodigo := vCliCheq;
                                 End If;
                              ElsIf vCartaoProprio = 'S' Then
                                 vTipo := 'D';
                              ElsIf vGravarTicktes = 'S' Then
                                 vTipo := 'T';
                              ElsIf vContasReceber = 'S' Then
                                 vTipo := 'B';
                              End If;
                              If vCodigo = 0 and ((vTipo = 'R') OR (vTipo = 'B')) Then
                                 vCodigo := vCliPref;
                              End If;
                              If not (r1.tipo_capa in (2) and (r1.tipo_recebimento = 20)) and (r1.tipo_capa <> 4) Then
                                 /*Danilo Caso 4858 - Socio torcedor - inicio*/
                                 if not (vCPF_CNPJ_SocioTorcedor is null) then
                                    vCNPJ := vCPF_CNPJ_SocioTorcedor;
                                 end if;
                                 /*Danilo Caso 4858 - Socio torcedor - fim*/
                                 --> Tipo 4 = vale gas
                                 if (vfinalizadorafrente = 17 and length(vNumeroAutorizacao) < 26) then -- Caso 0041836 - 21/11/2024 - Lázaro
                                    prc_raiseapplication('Ecommerce finalizado com PIX porem com número de dados incorreto. Corrigir Cupom! TXID:' || vNumeroAutorizacao || '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                                 end if;
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                  
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2870, 'EMPORIUM.EXPDET_SALE');
                                    SELECT (SELECT ES_AD.DATA_VALUE
                                              FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                             WHERE ES_AD.DATA_ID = 17
                                               AND ES_AD.POS_NUMBER = GFT.POS_NUMBER
                                               AND ES_AD.STORE_KEY = GFT.STORE_KEY
                                               AND ES_AD.TICKET_NUMBER = GFT.TICKET_NUMBER
                                               AND TRUNC(ES_AD.START_TIME) = TRUNC(GFT.START_TIME)
                                               AND ES_AD.DATA_LABEL = 'Numero_Cartao:') AS NUM_CRT
                                          ,'RESGATE' AS OPE
                                          ,(SELECT ES_AD.DATA_VALUE
                                              FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                             WHERE ES_AD.DATA_ID = 350
                                               AND ES_AD.POS_NUMBER = GFT.POS_NUMBER
                                               AND ES_AD.STORE_KEY = GFT.STORE_KEY
                                               AND ES_AD.TICKET_NUMBER = GFT.TICKET_NUMBER
                                               AND TRUNC(ES_AD.START_TIME) = TRUNC(GFT.START_TIME)) AS NSU
                                          ,'EFETIVO' AS SIT
                                          ,1 AS TIP_INT
                                      INTO vNUM_CRT
                                          ,vOPE
                                          ,vNSU
                                          ,vSIT
                                          ,vTIP_INT
                                      FROM EMPORIUM.EXPDET_SALE GFT
                                     WHERE GFT.SALE_TYPE = 127
                                          --AND GFT.OPER = 'RESGATE'
                                       AND TRUNC(GFT.START_TIME) = TRUNC(r2_2.DATA_MOVIMENTO)
                                       AND GFT.STORE_KEY = r2_2.NUMERO_LOJA
                                       AND GFT.POS_NUMBER = r2_2.NUMERO_PDV
                                       AND GFT.TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                                 Exception
                                    When no_data_found then
                                       vNUM_CRT := '';
                                       vOPE     := '';
                                       vNSU     := 0;
                                       vSIT     := '';
                                       vTIP_INT := '';
                                 end;
                                 BEGIN
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2912, 'FINALIZADORAS');
                                    SELECT FIN.PAYLESS INTO vPayless FROM FINALIZADORAS FIN WHERE FIN.Finalizadorafrente = intCodigoFinalizadora;
                                 EXCEPTION
                                    WHEN no_data_found THEN
                                       vPayless := 0;
                                 END;
                                 IF vPayless = 1 THEN
                                    -- Caso 0034746 - Henrique - 20/02/2024
                                    BEGIN
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2923, 'EMPORIUM.EXPDET_ANSWER_DATA');
                                       SELECT ES.DATA_VALUE
                                         INTO vOrder_Id
                                         FROM EMPORIUM.EXPDET_ANSWER_DATA ES
                                        WHERE ES.DATA_ID = 183
                                          AND TRUNC(ES.START_TIME) = TRUNC(r2_2.DATA_MOVIMENTO)
                                          AND ES.STORE_KEY = r2_2.NUMERO_LOJA
                                          AND ES.POS_NUMBER = r2_2.NUMERO_PDV
                                          AND ES.TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                                    EXCEPTION
                                       WHEN no_data_found THEN

                                           -- Tratamento para Payless e sem essa info. - Henrique 27/02
                                             RollBack;
                                             vErro          := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 183.';
                                             strErroDetalhe := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 183.';
                                             --prc_raiseapplication('Erro');
                                             If vLogImp = 'N' Then
                                                --Tratamento para deixar somente o ultimo log de um cupom
                                                -- Danilo 04/07/2013
                                                DELETE FROM LOG_IMPORTACAO
                                                 WHERE DATA = R1.DATA_VENDA
                                                      --             AND LOJA = intCodigoLoja
                                                   AND LOJA = r1.Numero_loja
                                                   AND PDV = R1.NUMERO_PDV
                                                   AND CUPOM = R1.NUMERO_CUPOM
                                                   AND CONECTO = 1;
                                                If instr(vErro, 'Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 183.') > 0 Then
                                                   strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                   UPDATE EMPORIUM.EXPDET_SALE ES
                                                      SET ES.STATUS = 3
                                                    WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                      AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                      AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                      AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                   INSERT INTO LOG_IMPORTACAO
                                                      (CHAVE
                                                      ,REGISTRO
                                                      ,TABELA
                                                      ,ERROBANCO
                                                      ,VERIFICADO
                                                      ,DATA
                                                      ,LOJA
                                                      ,PDV
                                                      ,CUPOM
                                                      ,CONECTO
                                                      ,ERROBANCO_DETALHES)
                                                   values
                                                      (log_importacao_seq.nextval
                                                      ,Substr(vDetalhe, 1, 200)
                                                      ,'EXPDET_ANSWER_DATA'
                                                      ,Substr(vErro, 1, 200)
                                                      ,0
                                                      ,R1.DATA_VENDA
                                                      ,R1.NUMERO_LOJA
                                                      ,R1.NUMERO_PDV
                                                      ,R1.NUMERO_CUPOM
                                                      ,1
                                                      ,strErroDetalhe);
                                                Else
                                                   BEGIN
                                                      SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                                                   EXCEPTION
                                                      WHEN NO_DATA_FOUND THEN
                                                         vCont := 0;
                                                   END;
                                                   IF vCont = 0 THEN
                                                      strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                      UPDATE EMPORIUM.EXPDET_SALE ES
                                                         SET ES.STATUS = 3
                                                       WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                         AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                         AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                         AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                      INSERT INTO LOG_IMPORTACAO
                                                         (CHAVE
                                                         ,REGISTRO
                                                         ,TABELA
                                                         ,ERROBANCO
                                                         ,VERIFICADO
                                                         ,DATA
                                                         ,LOJA
                                                         ,PDV
                                                         ,CUPOM
                                                         ,CONECTO
                                                         ,ERROBANCO_DETALHES)
                                                      values
                                                         (log_importacao_seq.nextval
                                                         ,Substr(vDetalhe, 1, 200)
                                                         ,'EMPORIUM.EXPDET_ANSWER_DATA'
                                                         ,Substr(vErro, 1, 200)
                                                         ,0
                                                         ,R1.DATA_VENDA
                                                         ,R1.NUMERO_LOJA
                                                         ,R1.NUMERO_PDV
                                                         ,R1.NUMERO_CUPOM
                                                         ,1
                                                         ,strErroDetalhe);
                                                   END IF;
                                                End If;
                                                vLogImp := 'S';
                                                commit;
                                             End If;

                                           -- Fim tratamento - Henrique 27/02

                                    END;
                                    -- Caso 0034746 - Henrique - 20/02/2024
                                    BEGIN
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3035, 'EMPORIUM.EXPDET_ANSWER_DATA');
                                       SELECT ES.DATA_VALUE
                                         INTO vAuth_Code
                                         FROM EMPORIUM.EXPDET_ANSWER_DATA ES
                                        WHERE ES.DATA_ID = 256
                                          AND TRUNC(ES.START_TIME) = TRUNC(r2_2.DATA_MOVIMENTO)
                                          AND ES.STORE_KEY = r2_2.NUMERO_LOJA
                                          AND ES.POS_NUMBER = r2_2.NUMERO_PDV
                                          AND ES.TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                                    EXCEPTION
                                       WHEN no_data_found THEN

                                            -- Tratamento para Payless e sem essa info. - Henrique 27/02
                                             RollBack;
                                             vErro          := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 183.';
                                             strErroDetalhe := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 183.';
                                             --prc_raiseapplication('Erro');
                                             If vLogImp = 'N' Then
                                                --Tratamento para deixar somente o ultimo log de um cupom
                                                -- Danilo 04/07/2013
                                                DELETE FROM LOG_IMPORTACAO
                                                 WHERE DATA = R1.DATA_VENDA
                                                      --             AND LOJA = intCodigoLoja
                                                   AND LOJA = r1.Numero_loja
                                                   AND PDV = R1.NUMERO_PDV
                                                   AND CUPOM = R1.NUMERO_CUPOM
                                                   AND CONECTO = 1;
                                                If instr(vErro, 'Não possui a informação do Authorization Code na tabela EXPDET_ANSWER_DATA - Id: 256.') > 0 Then
                                                   strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                   UPDATE EMPORIUM.EXPDET_SALE ES
                                                      SET ES.STATUS = 3
                                                    WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                      AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                      AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                      AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                   INSERT INTO LOG_IMPORTACAO
                                                      (CHAVE
                                                      ,REGISTRO
                                                      ,TABELA
                                                      ,ERROBANCO
                                                      ,VERIFICADO
                                                      ,DATA
                                                      ,LOJA
                                                      ,PDV
                                                      ,CUPOM
                                                      ,CONECTO
                                                      ,ERROBANCO_DETALHES)
                                                   values
                                                      (log_importacao_seq.nextval
                                                      ,Substr(vDetalhe, 1, 200)
                                                      ,'EXPDET_ANSWER_DATA'
                                                      ,Substr(vErro, 1, 200)
                                                      ,0
                                                      ,R1.DATA_VENDA
                                                      ,R1.NUMERO_LOJA
                                                      ,R1.NUMERO_PDV
                                                      ,R1.NUMERO_CUPOM
                                                      ,1
                                                      ,strErroDetalhe);
                                                Else
                                                   BEGIN
                                                      SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                                                   EXCEPTION
                                                      WHEN NO_DATA_FOUND THEN
                                                         vCont := 0;
                                                   END;
                                                   IF vCont = 0 THEN
                                                      strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                      UPDATE EMPORIUM.EXPDET_SALE ES
                                                         SET ES.STATUS = 3
                                                       WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                         AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                         AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                         AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                      INSERT INTO LOG_IMPORTACAO
                                                         (CHAVE
                                                         ,REGISTRO
                                                         ,TABELA
                                                         ,ERROBANCO
                                                         ,VERIFICADO
                                                         ,DATA
                                                         ,LOJA
                                                         ,PDV
                                                         ,CUPOM
                                                         ,CONECTO
                                                         ,ERROBANCO_DETALHES)
                                                      values
                                                         (log_importacao_seq.nextval
                                                         ,Substr(vDetalhe, 1, 200)
                                                         ,'EMPORIUM.EXPDET_ANSWER_DATA'
                                                         ,Substr(vErro, 1, 200)
                                                         ,0
                                                         ,R1.DATA_VENDA
                                                         ,R1.NUMERO_LOJA
                                                         ,R1.NUMERO_PDV
                                                         ,R1.NUMERO_CUPOM
                                                         ,1
                                                         ,strErroDetalhe);
                                                   END IF;
                                                End If;
                                                vLogImp := 'S';
                                                commit;
                                             End If;

                                           -- Fim tratamento - Henrique 27/02

                                    END;
                                 ELSE
                                    vOrder_Id  := NULL;
                                    vAuth_Code := NULL;
                                 END IF;
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3149, 'socin_finalizadoras_grava');                                
                                 socin_finalizadoras_grava(r2_2.Codigo_agencia, r2_2.Codigo_banco, '', --capturado
                                                           r2_2.Numero_cheque, r2_2.numero_conta, r2_2.codigo_conveniado, case when length(r2_2.codigo_convenio) > 6 then 0 else r2_2.codigo_convenio end, r2_2.numero_cpf_cnpj, vCNPJ, --CPF
                                                           r2_2.numero_cpf_cnpj, --CNPJ
                                                           vCodigo, --'',--Codigo
                                                           intCodigoLoja, r2_2.numero_cupom, r2_2.data_movimento, vVencimento,
                                                           --r2.codigo_finalizadora,
                                                           vfinalizadorafrente, 0, --r2.valor_juros,
                                                           r2_2.USUARIO_AUTORIZOU, --Liberou
                                                           r2_2.numero_pdv, 0, --Quantidade
                                                           r2_2.codigo_restricao, --Restricao Tef
                                                           --r2.sequencia,
                                                           intSequencia, r2_2.tipo_movimento, r2_2.tipo_troco, '', --Transmitido
                                                           0, --r2.troco,
                                                           fltTmpValor,
                                                           --ftmp.valor,
                                                           0, --valor tickets
                                                           r2_2.numero_cartao, --Via Brasil
                                                           vTipo, --Tipo
                                                           0, --Codigo Pai
                                                           'N', --Verifica
                                                           --'S', --Verifica
                                                           substr(TRIM(REPLACE(REPLACE(REPLACE(r2_2.CMC7_CHEQUE, '>', ''), '<', ''), ':', '')), 1, 30), --Tarja
                                                           NVL(SUBSTR(r2_2.CODIGO_BIN_TEF, 1, 6), 0), --Bandeira
                                                           -- MARCELO - 23/09/2008 - PROCESSO 76314
                                                           0, vQtd_Parcelas_TEF, r2_2.CODIGO_BANDEIRA, r2_2.CODIGO_ADMINISTRADORA, r2_2.TIPO_CARTAO, r2_2.OPERADOR_INFORM_ADM, vNumeroAutorizacao, '', vCodRoteador, fltValorDoacao, strNSU, --caso 20262 - 02/07/2018 - lorran
                                                           vNsu_host, -- Caso 22870 - Agnaldo  03/05/2019
                                                           vNUM_CRT, vOPE, vNSU, vSIT, vTIP_INT, vOrder_Id, vAuth_Code);
                                 if (fltValorDoacao > 0 and r2_2.troco = 0) AND strTipoFinalizadora = FINALIZADORAS_PKG.DINHEIRO then
                                    -- Caso 10968 - Danilo - 11/12/2015
                                    strMsmErroAdiciona := 'Doação sem Valor de Troco';
                                 End If;
                                 if strMsmErroAdiciona <> 'OK' then
                                    /* Existe algum problema com dados do processo do Socio Trocedor. Vlr e zerado para que o cupom n?o suba para o ERP*/
                                    vTotalFinalizadora := 0;
                                 else
                                    --                       vTotalFinalizadora := vTotalFinalizadora + (r2.valor - r2.troco + r2.valor_juros);
                                    vTotalFinalizadora := vTotalFinalizadora + (ftmp.valor);
                                    IF intPreVenda IN (12339431, 12343583, 12342991, 12343023, 12344147, 12343018, 12342978, 12348969, 12344748, 12344147, 12344147, 12343018, 12339431, 12343023, 12359496,13315758,13315683,13315909,13315891,13315853) THEN
                                       vTotalFinalizadora := vTotalCapa;
                                    END IF;
                                 End If;
                                 vCNPJ := '';
                              End If;
                              If r1.tipo_capa in (2) and (r1.tipo_recebimento = 20) Then
                                 --Pagamento de Duplicata
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(2923, 'clientes');
                                    select count(Codigo)
                                      into vCodigo
                                      from clientes
                                     where codigoconvenio = r1.codigo_convenio
                                       and CODIGOEMPRESA = r1.codigo_conveniado;
                                    If vCodigo = 1 Then
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                  
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3207, 'clientes');                                    
                                       select Codigo
                                         into vCodigo
                                         from clientes
                                        where codigoconvenio = r1.codigo_convenio
                                          and CODIGOEMPRESA = r1.codigo_conveniado;
                                    Else
                                       vCodigo := 0;
                                    End If;
                                 Exception
                                    when no_data_found Then
                                       vCodigo := 0;
                                 End;
                                 If vCodigo > 0 Then
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3224, 'pessoas');
                                       select nome into vNomeCliente from pessoas where codigo = vCodigo;
                                    Exception
                                       when no_data_found then
                                          vNomeCliente := 'CLIENTE NAO ENCONTRADO';
                                    End;
                                 End If;
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                               
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;  
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3234, 'caixa');                                                                
                                    Select codigo
                                      into vCaixa
                                      from caixa
                                     where loja = intCodigoLoja
                                       and baixapdv = 'S';
                                 Exception
                                    when no_data_found then
                                       vCaixa := 0;
                                 End;
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                            
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;     
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3247, 'caixa_movimento');
                                    Select aberto
                                      into vCaixaAberto
                                      from caixa_movimento
                                     where codigo = vCaixa
                                       and data = r2_2.data_movimento;
                                 Exception
                                    when no_data_found then
                                       vCaixaAberto := 'S';
                                 End;
                                 If vCaixa <> 0 and vCaixaAberto <> 'N' Then
                                    vChaveCaixa := 0;
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                            
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;     
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3262, 'caixa_detalhes');
                                       select chave
                                         into vChaveCaixa
                                         from caixa_detalhes
                                        where codigo = vCaixa
                                          and data = r2_2.data_movimento
                                          and usuario = 9999999
                                          and tipo = 'V'
                                          and loja = intCodigoLoja
                                          and valor = r2_2.valor - r2_2.troco;
                                    Exception
                                       when no_data_found Then
                                          vChaveCaixa := 0;
                                    End;
                                    If vChaveCaixa = 0 Then
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                            
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;     
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3280, 'Caixa_Detalhes');
                                       -- 72369 - Para nao gravar mais de uma vez no caixa, qdo reprocesso
                                       insert into Caixa_Detalhes
                                          (CODIGO
                                          ,DATA
                                          ,CHAVE
                                          ,USUARIO
                                          ,TIPO
                                          ,HISTORICO
                                          ,NIVEL1
                                          ,NIVEL2
                                          ,NIVEL3
                                          ,CHAVECENTROCUSTOS
                                          ,VALOR
                                          ,ORIGEM
                                          ,CODIGOORIGEM
                                          ,LOJA
                                          ,PEDIDO
                                          ,CHAVEORIGEM)
                                       Values
                                          (vCaixa
                                          ,r2_2.data_movimento
                                          ,CaixaDetalhes_seq.Nextval
                                          ,9999999
                                          ,'V'
                                          ,'REC CONTA: ' || Substr(vNomeCliente, 1, 39)
                                          ,0
                                          ,0
                                          ,0
                                          ,0
                                          ,r2_2.valor - r2_2.troco
                                          ,'PDV'
                                          ,vCaixa
                                          ,intCodigoLoja
                                          ,0
                                          ,0);
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                            
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;     
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3318, 'caixa_Finalizadoras');
                                       insert into caixa_Finalizadoras
                                          (VALOR
                                          ,CHAVE
                                          ,CODIGO
                                          ,DATA
                                          ,CAIXA
                                          ,CHAVEDETALHES
                                          ,TIPO
                                          ,VALORTRANSPORTADORA)
                                       Values
                                          (r2_2.valor - r2_2.troco
                                          ,CaixaFinalizadora_seq.Nextval
                                          ,vCodFinalizadora
                                          ,r2_2.data_movimento
                                          ,vCaixa
                                          ,caixadetalhes_seq.currval
                                          ,'C'
                                          ,0);
                                       If r2_2.valor_juros > 0 Then
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                               
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;     
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3340, 'Caixa_Detalhes');
                                          insert into Caixa_Detalhes
                                             (CODIGO
                                             ,DATA
                                             ,CHAVE
                                             ,USUARIO
                                             ,TIPO
                                             ,HISTORICO
                                             ,NIVEL1
                                             ,NIVEL2
                                             ,NIVEL3
                                             ,CHAVECENTROCUSTOS
                                             ,VALOR
                                             ,ORIGEM
                                             ,CODIGOORIGEM
                                             ,LOJA
                                             ,PEDIDO
                                             ,CHAVEORIGEM)
                                          Values
                                             (vCaixa
                                             ,r2_2.data_movimento
                                             ,CaixaDetalhes_seq.Nextval
                                             ,9999999
                                             ,'J'
                                             ,'JUROS REC CONTA: ' || Substr(vNomeCliente, 1, 33)
                                             ,0
                                             ,0
                                             ,0
                                             ,0
                                             ,r2_2.valor_juros
                                             ,'PDV'
                                             ,vCaixa
                                             ,intCodigoLoja
                                             ,0
                                             ,0);
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                  
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3376, 'caixa_Finalizadoras');
                                          insert into caixa_Finalizadoras
                                             (VALOR
                                             ,CHAVE
                                             ,CODIGO
                                             ,DATA
                                             ,CAIXA
                                             ,CHAVEDETALHES
                                             ,TIPO
                                             ,VALORTRANSPORTADORA)
                                          Values
                                             (r2_2.valor_juros
                                             ,CaixaFinalizadora_seq.Nextval
                                             ,vCodFinalizadora
                                             ,r2_2.data_movimento
                                             ,vCaixa
                                             ,caixadetalhes_seq.currval
                                             ,'C'
                                             ,0);
                                       End If;
                                    End If;
                                 End If;
                              End If;
                           end loop;
                        else
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                      
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3405, 'finalizadoras');
                              select Codigo
                                    ,fiado
                                    ,contasreceber
                                    ,chequesreceber
                                    ,cartaoproprio
                                    ,GRAVARTICKETS
                                into vCodFinalizadora
                                    ,vFiado
                                    ,vContasReceber
                                    ,vChequesReceber
                                    ,vCartaoProprio
                                    ,vGravarTicktes
                                from finalizadoras
                               where finalizadorafrente = vfinalizadorafrente; -- r2.codigo_finalizadora;
                           Exception
                              when no_data_found Then
                                 vFiado           := 'N';
                                 vContasReceber   := 'N';
                                 vChequesReceber  := 'N';
                                 vCartaoProprio   := 'N';
                                 vGravarTicktes   := 'N';
                                 vCodFinalizadora := 0;
                           End;
                           -- Caso 22078 - Lazaro - 25/01/2019
                           if (vCodFinalizadora = 0) Then
                              prc_raiseapplication('Código da Finalizadora não encontrado. Entre em contato com o Suporte! ' || '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                           End If;
                           BEGIN
                              vCodigoConvenio := r2_2.codigo_convenio;
                           EXCEPTION
                              WHEN OTHERS THEN
                                 vCodigoConvenio := 0;
                           END;
                           Begin
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                          
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3442, 'clientes');
                              select count(Codigo)
                                into vCodigo
                                from clientes
                               where codigoconvenio = vCodigoConvenio
--                               where codigoconvenio = r2_2.codigo_convenio
                                 and CODIGOEMPRESA = r2_2.codigo_conveniado;
                              If vCodigo = 1 Then
                                 select Codigo
                                   into vCodigo
                                   from clientes
                                  where codigoconvenio = r2_2.codigo_convenio
                                    and CODIGOEMPRESA = r2_2.codigo_conveniado;
                              Else
                                 vCodigo := 0;
                              End If;
                           Exception
                              when no_data_found Then
                                 vCodigo := 0;
                           End;
                           --Lazaro Vencimento do Cliente
                           If vCodigo <> 0 Then
                              Vencimento_cliente(vCodigo, r2_2.data_movimento, vVencimento);
                           End If;
                           If vFiado = 'S' Then
                              vTipo := 'R';
                           ElsIf (vChequesReceber = 'S') or (vContasReceber = 'S') Then
                              If (vChequesReceber = 'S') then
                                 vTipo := 'C';
                              End If;
                              if (vContasReceber = 'S') then
                                 vTipo := 'B';
                              End If;
                              If Length(r2_2.numero_cpf_cnpj) <= 7 then
                                 /*Caio  - Incio 89397*/
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3480, 'pessoas');
                                    select count(codigo) into vCont from pessoas where codigo = lpad(r2_2.numero_cpf_cnpj, 7, 0);
                                 Exception
                                    when no_data_found then
                                       vCont := 0;
                                 End;
                                 if vCont > 1 then
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3490, 'pessoas');
                                       select codigo
                                         into vCodigo
                                         from pessoas
                                        where codigo = lpad(r2_2.numero_cpf_cnpj, 7, 0)
                                          and cliente = 'S'
                                          and rownum = 1;
                                    Exception
                                       when no_data_found then
                                          vCodigo := vCliCheq;
                                    end;
                                 else
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                     
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3505, 'pessoas');
                                       select codigo into vCodigo from pessoas where codigo = lpad(r2_2.numero_cpf_cnpj, 7, 0);
                                    Exception
                                       when no_data_found then
                                          vCodigo := vCliCheq;
                                    End;
                                 End If;
                              End If; /*Caio  - Fim 89397*/
                              If Length(r2_2.numero_cpf_cnpj) >= 7 and Length(r2_2.numero_cpf_cnpj) <= 11 Then
                                 /*Caio  - 89397*/
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                      
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3518, 'pessoas');
                                    select count(codigo) into vCont from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '')) = lpad(r2_2.numero_cpf_cnpj, 11, 0);
                                 Exception
                                    when no_data_found then
                                       vCont := 0;
                                 end;
                                 if vCont > 1 then
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                         
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3528, 'pessoas');
                                       select codigo
                                         into vCodigo
                                         from pessoas
                                        where TRIM(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '')) = lpad(r2_2.numero_cpf_cnpj, 11, 0)
                                          and cliente = 'S'
                                          and rownum = 1;
                                    Exception
                                       when no_data_found then
                                          vCodigo := vCliCheq;
                                    end;
                                 else
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3543, 'pessoas');
                                       select codigo into vCodigo from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), '/', '')) = lpad(r2_2.numero_cpf_cnpj, 11, 0);
                                    Exception
                                       when no_data_found then
                                          vCodigo := vCliCheq;
                                    End;
                                 End If;
                              End If;
                              If Length(r2_2.numero_cpf_cnpj) > 11 Then
                                 /*Caio  - 89397*/
                                 Begin
                                    --Alterado para tratar o CNPJ maior que 14 digitos - Lazaro - 04-06-2008
                                    If Length(r2_2.numero_cpf_cnpj) = 16 Then
                                       vCNPJ := Substr(r2_2.numero_cpf_cnpj, 3, 14);
                                    ElsIf Length(r2_2.numero_cpf_cnpj) = 15 Then
                                       vCNPJ := Substr(r2_2.numero_cpf_cnpj, 2, 14);
                                    Else
                                       vCNPJ := r2_2.numero_cpf_cnpj;
                                    End If;
                                    vCNPJ := lpad(vCNPJ, 14, 0);
                                    Begin
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3566, 'pessoas');
                                       select count(codigo) into vCont from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '')) = vCNPJ;
                                    Exception
                                       when no_data_found then
                                          vCont := 0;
                                    End;
                                    if vCont > 1 then
                                       Begin
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3576, 'pessoas');
                                          select codigo
                                            into vCodigo
                                            from pessoas
                                           where TRIM(REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '')) = vCNPJ
                                             and cliente = 'S'
                                             and rownum = 1;
                                       Exception
                                          when no_data_found then
                                             vCodigo := vCliCheq;
                                       End;
                                    else
                                       Begin
                                          /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                          PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                          PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3591, 'pessoas');
                                          select codigo into vCodigo from pessoas where TRIM(REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '-', ''), '/', '')) = vCNPJ;
                                       Exception
                                          when no_data_found then
                                             vCodigo := vCliCheq;
                                       End;
                                    End if;
                                 End;
                              Else
                                 vCNPJ := r2_2.numero_cpf_cnpj;
                              End If;
                              If vCodigo = 0 Then
                                 vCodigo := vCliCheq;
                              End If;
                           ElsIf vCartaoProprio = 'S' Then
                              vTipo := 'D';
                           ElsIf vGravarTicktes = 'S' Then
                              vTipo := 'T';
                           ElsIf vContasReceber = 'S' Then
                              vTipo := 'B';
                           End If;
                           If vCodigo = 0 and ((vTipo = 'R') OR (vTipo = 'B')) Then
                              vCodigo := vCliPref;
                           End If;
                           If not (r1.tipo_capa in (2) and (r1.tipo_recebimento = 20)) and (r1.tipo_capa <> 4) Then
                              /* Socio torcedor - inicio */
                              if not (vCPF_CNPJ_SocioTorcedor is null) then
                                 vCNPJ := vCPF_CNPJ_SocioTorcedor;
                              end if;
                              /* Socio torcedor - fim */
                              --> Tipo 4 = vale gas
                              if (vfinalizadorafrente = 17 and length(vNumeroAutorizacao) < 26) then -- Caso 0041836 - 21/11/2024 - Lázaro
                                 prc_raiseapplication('Ecommerce finalizado com PIX porem com número de dados incorreto. Corrigir Cupom! TXID:' || vNumeroAutorizacao || ' - Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                              end if;
                              Begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                  
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3628, 'EMPORIUM.EXPDET_SALE');
                                 SELECT (SELECT ES_AD.DATA_VALUE
                                           FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                          WHERE ES_AD.DATA_ID = 17
                                            AND ES_AD.POS_NUMBER = GFT.POS_NUMBER
                                            AND ES_AD.STORE_KEY = GFT.STORE_KEY
                                            AND ES_AD.TICKET_NUMBER = GFT.TICKET_NUMBER
                                            AND TRUNC(ES_AD.START_TIME) = TRUNC(GFT.START_TIME)) AS NUM_CRT
                                       ,'RESGATE' AS OPE
                                       ,(SELECT ES_AD.DATA_VALUE
                                           FROM EMPORIUM.EXPDET_ANSWER_DATA ES_AD
                                          WHERE ES_AD.DATA_ID = 350
                                            AND ES_AD.POS_NUMBER = GFT.POS_NUMBER
                                            AND ES_AD.STORE_KEY = GFT.STORE_KEY
                                            AND ES_AD.TICKET_NUMBER = GFT.TICKET_NUMBER
                                            AND TRUNC(ES_AD.START_TIME) = TRUNC(GFT.START_TIME)
                                            AND ES_AD.DATA_LABEL = 'Numero_Cartao:') AS NSU
                                       ,'EFETIVO' AS SIT
                                       ,1 AS TIP_INT
                                   INTO vNUM_CRT
                                       ,vOPE
                                       ,vNSU
                                       ,vSIT
                                       ,vTIP_INT
                                   FROM EMPORIUM.EXPDET_SALE GFT
                                  WHERE GFT.SALE_TYPE = 127
                                       --AND GFT.OPER = 'RESGATE'
                                    AND TRUNC(GFT.START_TIME) = TRUNC(r2_2.DATA_MOVIMENTO)
                                    AND GFT.STORE_KEY = r2_2.NUMERO_LOJA
                                    AND GFT.POS_NUMBER = r2_2.NUMERO_PDV
                                    AND GFT.TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                              Exception
                                 When no_data_found then
                                    vNUM_CRT := '';
                                    vOPE     := '';
                                    vNSU     := 0;
                                    vSIT     := '';
                                    vTIP_INT := '';
                              end;
                              BEGIN
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3670, 'FINALIZADORAS');
                                 SELECT FIN.PAYLESS INTO vPayless FROM FINALIZADORAS FIN WHERE FIN.Finalizadorafrente = intCodigoFinalizadora;
                              EXCEPTION
                                 WHEN no_data_found THEN
                                    vPayless := 0;
                              END;
                              IF vPayless = 1 THEN
                                 -- Caso 0034746 - Henrique - 20/02/2024
                                 BEGIN
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3681, 'EMPORIUM.EXPDET_ANSWER_DATA');                                 
                                    SELECT ES.DATA_VALUE
                                      INTO vOrder_Id
                                      FROM EMPORIUM.EXPDET_ANSWER_DATA ES
                                     WHERE ES.DATA_ID = 183
                                       AND TRUNC(ES.START_TIME) = TRUNC(r2_2.DATA_MOVIMENTO)
                                       AND ES.STORE_KEY = r2_2.NUMERO_LOJA
                                       AND ES.POS_NUMBER = r2_2.NUMERO_PDV
                                       AND ES.TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                                 EXCEPTION
                                    WHEN no_data_found THEN
                                       -- Tratamento para Payless e sem essa info. - Henrique 27/02
                                             RollBack;
                                             vErro          := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 183.';
                                             strErroDetalhe := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 183.';
                                             --prc_raiseapplication('Erro');
                                             If vLogImp = 'N' Then
                                                --Tratamento para deixar somente o ultimo log de um cupom
                                                -- Danilo 04/07/2013
                                                DELETE FROM LOG_IMPORTACAO
                                                 WHERE DATA = R1.DATA_VENDA
                                                      --             AND LOJA = intCodigoLoja
                                                   AND LOJA = r1.Numero_loja
                                                   AND PDV = R1.NUMERO_PDV
                                                   AND CUPOM = R1.NUMERO_CUPOM
                                                   AND CONECTO = 1;

                                                If instr(vErro, 'Não possui a informação do Authorization Code na tabela EXPDET_ANSWER_DATA - Id: 183.') > 0 Then
                                                   strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                   UPDATE EMPORIUM.EXPDET_SALE ES
                                                      SET ES.STATUS = 3
                                                    WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                      AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                      AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                      AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                   INSERT INTO LOG_IMPORTACAO
                                                      (CHAVE
                                                      ,REGISTRO
                                                      ,TABELA
                                                      ,ERROBANCO
                                                      ,VERIFICADO
                                                      ,DATA
                                                      ,LOJA
                                                      ,PDV
                                                      ,CUPOM
                                                      ,CONECTO
                                                      ,ERROBANCO_DETALHES)
                                                   values
                                                      (log_importacao_seq.nextval
                                                      ,Substr(vDetalhe, 1, 200)
                                                      ,'EXPDET_ANSWER_DATA'
                                                      ,Substr(vErro, 1, 200)
                                                      ,0
                                                      ,R1.DATA_VENDA
                                                      ,R1.NUMERO_LOJA
                                                      ,R1.NUMERO_PDV
                                                      ,R1.NUMERO_CUPOM
                                                      ,1
                                                      ,strErroDetalhe);
                                                Else
                                                   BEGIN
                                                      SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                                                   EXCEPTION
                                                      WHEN NO_DATA_FOUND THEN
                                                         vCont := 0;
                                                   END;
                                                   IF vCont = 0 THEN
                                                      strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                      UPDATE EMPORIUM.EXPDET_SALE ES
                                                         SET ES.STATUS = 3
                                                       WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                         AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                         AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                         AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                      INSERT INTO LOG_IMPORTACAO
                                                         (CHAVE
                                                         ,REGISTRO
                                                         ,TABELA
                                                         ,ERROBANCO
                                                         ,VERIFICADO
                                                         ,DATA
                                                         ,LOJA
                                                         ,PDV
                                                         ,CUPOM
                                                         ,CONECTO
                                                         ,ERROBANCO_DETALHES)
                                                      values
                                                         (log_importacao_seq.nextval
                                                         ,Substr(vDetalhe, 1, 200)
                                                         ,'EMPORIUM.EXPDET_ANSWER_DATA'
                                                         ,Substr(vErro, 1, 200)
                                                         ,0
                                                         ,R1.DATA_VENDA
                                                         ,R1.NUMERO_LOJA
                                                         ,R1.NUMERO_PDV
                                                         ,R1.NUMERO_CUPOM
                                                         ,1
                                                         ,strErroDetalhe);
                                                   END IF;
                                                End If;
                                                vLogImp := 'S';
                                                commit;
                                             End If;

                                           -- Fim tratamento - Henrique 27/02
                                 END;
                                 -- Caso 0034746 - Henrique - 20/02/2024
                                 BEGIN
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3791, 'EMPORIUM.EXPDET_ANSWER_DATA');                                 
                                    SELECT ES.DATA_VALUE
                                      INTO vAuth_Code
                                      FROM EMPORIUM.EXPDET_ANSWER_DATA ES
                                     WHERE ES.DATA_ID = 256
                                       AND TRUNC(ES.START_TIME) = TRUNC(r2_2.DATA_MOVIMENTO)
                                       AND ES.STORE_KEY = r2_2.NUMERO_LOJA
                                       AND ES.POS_NUMBER = r2_2.NUMERO_PDV
                                       AND ES.TICKET_NUMBER = r2_2.NUMERO_CUPOM;
                                 EXCEPTION
                                    WHEN no_data_found THEN
                                       -- Tratamento para Payless e sem essa info. - Henrique 27/02
                                             RollBack;
                                             vErro          := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 256.';
                                             strErroDetalhe := 'Erro ao Importar Finalizadora - Não possui a informação do Order Id na tabela EXPDET_ANSWER_DATA - Id: 256.';
                                             --prc_raiseapplication('Erro');
                                             If vLogImp = 'N' Then
                                                --Tratamento para deixar somente o ultimo log de um cupom
                                                -- Danilo 04/07/2013
                                                DELETE FROM LOG_IMPORTACAO
                                                 WHERE DATA = R1.DATA_VENDA
                                                      --             AND LOJA = intCodigoLoja
                                                   AND LOJA = r1.Numero_loja
                                                   AND PDV = R1.NUMERO_PDV
                                                   AND CUPOM = R1.NUMERO_CUPOM
                                                   AND CONECTO = 1;
                                                If instr(vErro, 'Não possui a informação do Authorization Code na tabela EXPDET_ANSWER_DATA - Id: 256.') > 0 Then
                                                   strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                   UPDATE EMPORIUM.EXPDET_SALE ES
                                                      SET ES.STATUS = 3
                                                    WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                      AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                      AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                      AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                   INSERT INTO LOG_IMPORTACAO
                                                      (CHAVE
                                                      ,REGISTRO
                                                      ,TABELA
                                                      ,ERROBANCO
                                                      ,VERIFICADO
                                                      ,DATA
                                                      ,LOJA
                                                      ,PDV
                                                      ,CUPOM
                                                      ,CONECTO
                                                      ,ERROBANCO_DETALHES)
                                                   values
                                                      (log_importacao_seq.nextval
                                                      ,Substr(vDetalhe, 1, 200)
                                                      ,'EXPDET_ANSWER_DATA'
                                                      ,Substr(vErro, 1, 200)
                                                      ,0
                                                      ,R1.DATA_VENDA
                                                      ,R1.NUMERO_LOJA
                                                      ,R1.NUMERO_PDV
                                                      ,R1.NUMERO_CUPOM
                                                      ,1
                                                      ,strErroDetalhe);
                                                Else
                                                   BEGIN
                                                      SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                                                   EXCEPTION
                                                      WHEN NO_DATA_FOUND THEN
                                                         vCont := 0;
                                                   END;
                                                   IF vCont = 0 THEN
                                                      strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                                      UPDATE EMPORIUM.EXPDET_SALE ES
                                                         SET ES.STATUS = 3
                                                       WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                                         AND ES.STORE_KEY = R1.NUMERO_LOJA
                                                         AND ES.POS_NUMBER = R1.NUMERO_PDV
                                                         AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                                      INSERT INTO LOG_IMPORTACAO
                                                         (CHAVE
                                                         ,REGISTRO
                                                         ,TABELA
                                                         ,ERROBANCO
                                                         ,VERIFICADO
                                                         ,DATA
                                                         ,LOJA
                                                         ,PDV
                                                         ,CUPOM
                                                         ,CONECTO
                                                         ,ERROBANCO_DETALHES)
                                                      values
                                                         (log_importacao_seq.nextval
                                                         ,Substr(vDetalhe, 1, 200)
                                                         ,'EMPORIUM.EXPDET_ANSWER_DATA'
                                                         ,Substr(vErro, 1, 200)
                                                         ,0
                                                         ,R1.DATA_VENDA
                                                         ,R1.NUMERO_LOJA
                                                         ,R1.NUMERO_PDV
                                                         ,R1.NUMERO_CUPOM
                                                         ,1
                                                         ,strErroDetalhe);
                                                   END IF;
                                                End If;
                                                vLogImp := 'S';
                                                commit;
                                             End If;

                                           -- Fim tratamento - Henrique 27/02
                                 END;
                              ELSE
                                 vOrder_Id  := NULL;
                                 vAuth_Code := NULL;
                              END IF;

                              --Caso .... - Caio - 07/10/2025
                              --O código do roteador é o mesmo que a administradora. Mmantive a lógica criada anteriormente por alguém.
                              intCodigoAdministradora := r2_2.CODIGO_ADMINISTRADORA;
                              strCodigoBandeira       := NVL(SUBSTR(r2_2.CODIGO_BIN_TEF, 1, 6), 0);
                              IF blnFinalizadoraCartaoVirtual THEN
                                 intCodigoAdministradora := VITRUVIO.FNC_CONFIG('ecxCodAdmSuperus');
                                 vCodRoteador            := VITRUVIO.FNC_CONFIG('ecxCodRoteadorAdm');
                                 strCodigoBandeira       := '-1'; --ZERO PARA PEGAR SEMPRE A ADMINISTRADORA CONFIGURADA NO VITRUVIO
                              END IF;

                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3912, 'SOCIN_FINALIZADORAS_GRAVA');                                 
                              SOCIN_FINALIZADORAS_GRAVA(ParAgencia              => r2_2.Codigo_agencia
                                                       ,ParBanco                => r2_2.Codigo_banco
                                                       ,ParCapturado            => '' --capturado
                                                       ,ParCheque               => r2_2.Numero_cheque
                                                       ,ParContaCorrente        => r2_2.numero_conta
                                                       ,ParConveniado           => r2_2.codigo_conveniado
                                                       ,ParConvenio             => case when length(r2_2.codigo_convenio) > 6 then 0 else r2_2.codigo_convenio end
                                                       ,ParCPF_CNPJ             => r2_2.numero_cpf_cnpj
                                                       ,ParCPF                  => vCNPJ --CPF
                                                       ,ParCNPJ                 => r2_2.numero_cpf_cnpj --CNPJ
                                                       ,ParCodigo               => vCodigo
                                                       ,ParLoja                 => intCodigoLoja
                                                       ,ParCupom                => r2_2.numero_cupom
                                                       ,ParData                 => r2_2.data_movimento
                                                       ,ParDataDeposito         => vVencimento
                                                       ,ParFinalizadora         => vfinalizadorafrente
                                                       ,ParJuros                => r2_2.valor_juros
                                                       ,ParLiberou              => r2_2.USUARIO_AUTORIZOU --Liberou
                                                       ,ParPDV                  => r2_2.numero_pdv
                                                       ,ParQUANTIDADE_TICKETS   => 0 --Quantidade
                                                       ,ParRestricao_TEF        => r2_2.codigo_restricao --Restricao Tef
                                                       ,ParSequencia            => r2_2.sequencia
                                                       ,ParTipo_Movimento       => r2_2.tipo_movimento
                                                       ,ParTipo_Troco           => r2_2.tipo_troco
                                                       ,ParTransmitido          => '' --Transmitido
                                                       ,ParTroco                => r2_2.troco
                                                       ,ParValor                => r2_2.valor
                                                       ,ParValor_Tickets        => 0 --valor tickets
                                                       ,ParViaBrasil            => replace(r2_2.numero_cartao, '*******', '******') --Via Brasil
                                                       ,ParTipo                 => vTipo --Tipo
                                                       ,ParCodigoPai            => 0 --Codigo Pai
                                                       ,ParVerifica             => 'N' --Verifica
                                                       ,ParTarja                => substr(TRIM(REPLACE(REPLACE(REPLACE(r2_2.CMC7_CHEQUE, '>', ''), '<', ''), ':', '')), 1, 30) --Tarja
                                                       ,ParBandeira             => strCodigoBandeira --Bandeira
                                                       ,ParAdministradoraFrente => 0
                                                       ,PARQTDPARCELASTEF       => vQtd_Parcelas_TEF
                                                       ,PARCODIGOBANDEIRA       => r2_2.CODIGO_BANDEIRA
                                                       ,PARCODIGOADM            => intCodigoAdministradora
                                                       ,PARTIPOCARTAO           => r2_2.TIPO_CARTAO
                                                       ,PAROPERADORINFADM       => r2_2.OPERADOR_INFORM_ADM
                                                       ,PARNUMEROAUTORIZACAO    => vNumeroAutorizacao
                                                       ,ParNumeroDocumento      => ''
                                                       ,ParCodRoteador          => vCodRoteador
                                                       ,ParValorDoacao          => fltValorDoacao
                                                       ,ParNSU                  => strNSU --caso 20262 - 02/07/2018 - lorran
                                                       ,ParNSU_HOST             => vNsu_host -- Caso 22870 - Agnaldo  03/05/2019
                                                       ,ParNumeroCartao         => vNUM_CRT
                                                       ,ParOperacaoCartao       => vOPE
                                                       ,ParNSUCartao            => vNSU
                                                       ,ParSituacaoCartao       => vSIT
                                                       ,ParTipoIntegracao       => vTIP_INT
                                                       ,ParOrderId              => vOrder_Id
                                                       ,ParAuthCode             => vAuth_Code);

                              if (fltValorDoacao > 0 and r2_2.troco = 0) AND strTipoFinalizadora = FINALIZADORAS_PKG.DINHEIRO then
                                 -- Caso 10968 - Danilo - 11/12/2015
                                 strMsmErroAdiciona := 'Doação sem Valor de Troco';
                              End If;
                              if strMsmErroAdiciona <> 'OK' then
                                 /* Existe algum problema com dados do processo do Socio Trocedor. Vlr e zerado para que o cupom n?o suba para o ERP*/
                                 vTotalFinalizadora := 0;
                              else
                                 --Caso 43573 - Caio - 24/04/2025
                                 IF strTipoFinalizadora <> FINALIZADORAS_PKG.DINHEIRO AND fltValorDoacao > 0 THEN
                                    vTotalFinalizadora := vTotalFinalizadora + r2_2.valor - r2_2.troco - fltValorDoacao;
                                 ELSE
                                    vTotalFinalizadora := vTotalFinalizadora + r2_2.valor - r2_2.troco;
                                 END IF;
                              End If;
                              vCNPJ := '';
                           End If;
                           If r1.tipo_capa in (2) and (r1.tipo_recebimento = 20) Then
                              --Pagamento de Duplicata
                              Begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3989, 'clientes');                                 
                                 select count(Codigo)
                                   into vCodigo
                                   from clientes
                                  where codigoconvenio = r1.codigo_convenio
                                    and CODIGOEMPRESA = r1.codigo_conveniado;
                                 If vCodigo = 1 Then
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                               
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(3998, 'clientes');
                                    select Codigo
                                      into vCodigo
                                      from clientes
                                     where codigoconvenio = r1.codigo_convenio
                                       and CODIGOEMPRESA = r1.codigo_conveniado;
                                 Else
                                    vCodigo := 0;
                                 End If;
                              Exception
                                 when no_data_found Then
                                    vCodigo := 0;
                              End;
                              If vCodigo > 0 Then
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                               
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4015, 'pessoas');
                                    select nome into vNomeCliente from pessoas where codigo = vCodigo;
                                 Exception
                                    when no_data_found then
                                       vNomeCliente := 'CLIENTE NAO ENCONTRADO';
                                 End;
                              End If;
                              Begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                              
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4015, 'pessoas');
                                 Select codigo
                                   into vCaixa
                                   from caixa
                                  where loja = intCodigoLoja
                                    and baixapdv = 'S';
                              Exception
                                 when no_data_found then
                                    vCaixa := 0;
                              End;
                              Begin
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                              
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4038, 'caixa_movimento');
                                 Select aberto
                                   into vCaixaAberto
                                   from caixa_movimento
                                  where codigo = vCaixa
                                    and data = r2_2.data_movimento;
                              Exception
                                 when no_data_found then
                                    vCaixaAberto := 'S';
                              End;
                              If vCaixa <> 0 and vCaixaAberto <> 'N' Then
                                 vChaveCaixa := 0;
                                 Begin
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4053, 'caixa_detalhes');
                                    select chave
                                      into vChaveCaixa
                                      from caixa_detalhes
                                     where codigo = vCaixa
                                       and data = r2_2.data_movimento
                                       and usuario = 9999999
                                       and tipo = 'V'
                                       and loja = intCodigoLoja
                                       and valor = r2_2.valor - r2_2.troco;
                                 Exception
                                    when no_data_found Then
                                       vChaveCaixa := 0;
                                 End;
                                 If vChaveCaixa = 0 Then
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                     
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;        
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4071, 'Caixa_Detalhes');
                                    -- 72369 - Para nao gravar mais de uma vez no caixa, qdo reprocesso
                                    insert into Caixa_Detalhes
                                       (CODIGO
                                       ,DATA
                                       ,CHAVE
                                       ,USUARIO
                                       ,TIPO
                                       ,HISTORICO
                                       ,NIVEL1
                                       ,NIVEL2
                                       ,NIVEL3
                                       ,CHAVECENTROCUSTOS
                                       ,VALOR
                                       ,ORIGEM
                                       ,CODIGOORIGEM
                                       ,LOJA
                                       ,PEDIDO
                                       ,CHAVEORIGEM)
                                    Values
                                       (vCaixa
                                       ,r2_2.data_movimento
                                       ,CaixaDetalhes_seq.Nextval
                                       ,9999999
                                       ,'V'
                                       ,'REC CONTA: ' || Substr(vNomeCliente, 1, 39)
                                       ,0
                                       ,0
                                       ,0
                                       ,0
                                       ,r2_2.valor - r2_2.troco
                                       ,'PDV'
                                       ,vCaixa
                                       ,intCodigoLoja
                                       ,0
                                       ,0);
                                    /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                                    PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                                    PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4108, 'caixa_Finalizadoras');
                                    insert into caixa_Finalizadoras
                                       (VALOR
                                       ,CHAVE
                                       ,CODIGO
                                       ,DATA
                                       ,CAIXA
                                       ,CHAVEDETALHES
                                       ,TIPO
                                       ,VALORTRANSPORTADORA)
                                    Values
                                       (r2_2.valor - r2_2.troco
                                       ,CaixaFinalizadora_seq.Nextval
                                       ,vCodFinalizadora
                                       ,r2_2.data_movimento
                                       ,vCaixa
                                       ,caixadetalhes_seq.currval
                                       ,'C'
                                       ,0);
                                    If r2_2.valor_juros > 0 Then
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4130, 'Caixa_Detalhes');
                                       insert into Caixa_Detalhes
                                          (CODIGO
                                          ,DATA
                                          ,CHAVE
                                          ,USUARIO
                                          ,TIPO
                                          ,HISTORICO
                                          ,NIVEL1
                                          ,NIVEL2
                                          ,NIVEL3
                                          ,CHAVECENTROCUSTOS
                                          ,VALOR
                                          ,ORIGEM
                                          ,CODIGOORIGEM
                                          ,LOJA
                                          ,PEDIDO
                                          ,CHAVEORIGEM)
                                       Values
                                          (vCaixa
                                          ,r2_2.data_movimento
                                          ,CaixaDetalhes_seq.Nextval
                                          ,9999999
                                          ,'J'
                                          ,'JUROS REC CONTA: ' || Substr(vNomeCliente, 1, 33)
                                          ,0
                                          ,0
                                          ,0
                                          ,0
                                          ,r2_2.valor_juros
                                          ,'PDV'
                                          ,vCaixa
                                          ,intCodigoLoja
                                          ,0
                                          ,0);
                                       /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                                       PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;              
                                       PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4167, 'caixa_Finalizadoras');   
                                       insert into caixa_Finalizadoras
                                          (VALOR
                                          ,CHAVE
                                          ,CODIGO
                                          ,DATA
                                          ,CAIXA
                                          ,CHAVEDETALHES
                                          ,TIPO
                                          ,VALORTRANSPORTADORA)
                                       Values
                                          (r2_2.valor_juros
                                          ,CaixaFinalizadora_seq.Nextval
                                          ,vCodFinalizadora
                                          ,r2_2.data_movimento
                                          ,vCaixa
                                          ,caixadetalhes_seq.currval
                                          ,'C'
                                          ,0);
                                    End If;
                                 End If;
                              End If;
                           End If;
                        end if;

                        --Caso 43573 - Caio - 24/04/2025
                        --SOMENTE SE CUPOM FOR NORMAL E NÃO FOR DINHEIRO
                        IF fltValorDoacao > 0 AND R1.SITUACAO_CAPA NOT IN (2, 9) AND strTipoFinalizadora <> FINALIZADORAS_PKG.DINHEIRO THEN
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4197, 'PRC_VENDA_DOACAO_CARTAO_PIX');
                           PRC_VENDA_DOACAO_CARTAO_PIX(ParTipo         => 'I'
                                                      ,ParData         => R1.DATA_VENDA
                                                      ,ParLoja         => intCodigoLoja
                                                      ,ParNumeroLoja   => R1.NUMERO_LOJA
                                                      ,ParPDV          => R1.NUMERO_PDV
                                                      ,ParCupom        => R1.NUMERO_CUPOM
                                                      ,ParSequencia    => R2_2.SEQUENCIA
                                                      ,ParFinalizadora => intCodigoFinalizadora
                                                      ,ParValor        => fltValorDoacao);
                        END IF;
                     End Loop;
                     --Caso 33713 - Caio Guelre - 03/01/2023
                     --ACERTO DE CUPOM DEVOLUÇÃO DE COOPERADO
                     IF vReprocesso = 'S' THEN
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4214, 'PEDIDOS_CUPOM_DEVOLUCAO/PEDIDOS_ITENS');
                        FOR c_DEV IN (SELECT DISTINCT PI.CHAVEPEDIDO
                                        FROM PEDIDOS_CUPOM_DEVOLUCAO PCD
                                            ,PEDIDOS_ITENS           PI
                                       WHERE PCD.CHAVEITEMPEDIDO = PI.CHAVE
                                         AND PCD.DATA = R1.DATA_VENDA
                                         AND PCD.LOJA = intCodigoLoja
                                         AND PCD.PDV = R1.NUMERO_PDV
                                         AND PCD.CUPOM = R1.NUMERO_CUPOM)
                        LOOP
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4226, 'PRC_DEV_CONVENIOS');
                           PRC_DEV_CONVENIOS(ParChavePed => c_DEV.CHAVEPEDIDO, ParTipo => 'A');
                        END LOOP;
                     END IF;
                  Exception
                     when Others then
                        --null;
                        RollBack;
                        vErro          := 'Erro ao Importar Finalizadora - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                        strErroDetalhe := 'Erro ao Importar Finalizadora - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                        --prc_raiseapplication('Erro');
                        If vLogImp = 'N' Then
                           --Tratamento para deixar somente o ultimo log de um cupom
                           -- Danilo 04/07/2013
                           DELETE FROM LOG_IMPORTACAO
                            WHERE DATA = R1.DATA_VENDA
                                 --             AND LOJA = intCodigoLoja
                              AND LOJA = r1.Numero_loja
                              AND PDV = R1.NUMERO_PDV
                              AND CUPOM = R1.NUMERO_CUPOM
                              AND CONECTO = 1;
                           If instr(vErro, 'Ecommerce finalizado com PIX porem sem TXID informado.') > 0 Then
                              strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                              UPDATE EMPORIUM.EXPDET_SALE ES
                                 SET ES.STATUS = 3
                               WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                 AND ES.STORE_KEY = R1.NUMERO_LOJA
                                 AND ES.POS_NUMBER = R1.NUMERO_PDV
                                 AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                              INSERT INTO LOG_IMPORTACAO
                                 (CHAVE
                                 ,REGISTRO
                                 ,TABELA
                                 ,ERROBANCO
                                 ,VERIFICADO
                                 ,DATA
                                 ,LOJA
                                 ,PDV
                                 ,CUPOM
                                 ,CONECTO
                                 ,ERROBANCO_DETALHES)
                              values
                                 (log_importacao_seq.nextval
                                 ,Substr(vDetalhe, 1, 200)
                                 ,'DIVERGENCIA'
                                 ,Substr(vErro, 1, 200)
                                 ,0
                                 ,R1.DATA_VENDA
                                 ,R1.NUMERO_LOJA
                                 ,R1.NUMERO_PDV
                                 ,R1.NUMERO_CUPOM
                                 ,1
                                 ,strErroDetalhe);
                           Else
                              BEGIN
                                 SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                              EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                    vCont := 0;
                              END;

                              IF vCont = 0 THEN
                                 strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                 UPDATE EMPORIUM.EXPDET_SALE ES
                                    SET ES.STATUS = 3
                                  WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                    AND ES.STORE_KEY = R1.NUMERO_LOJA
                                    AND ES.POS_NUMBER = R1.NUMERO_PDV
                                    AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                 INSERT INTO LOG_IMPORTACAO
                                    (CHAVE
                                    ,REGISTRO
                                    ,TABELA
                                    ,ERROBANCO
                                    ,VERIFICADO
                                    ,DATA
                                    ,LOJA
                                    ,PDV
                                    ,CUPOM
                                    ,CONECTO
                                    ,ERROBANCO_DETALHES)
                                 values
                                    (log_importacao_seq.nextval
                                    ,Substr(vDetalhe, 1, 200)
                                    ,'EMPORIUM.EXPDET_SALE_MEDIA'
                                    ,Substr(vErro, 1, 200)
                                    ,0
                                    ,R1.DATA_VENDA
                                    ,R1.NUMERO_LOJA
                                    ,R1.NUMERO_PDV
                                    ,R1.NUMERO_CUPOM
                                    ,1
                                    ,strErroDetalhe);
                              END IF;
                           End If;
                           vLogImp := 'S';
                           commit;
                        End If;
                        --raise_application_error(-20001,'Erro ao Importar Finalizadora - Cupom: '||' '||r1.numero_cupom||' --- '||SQLCODE||' -ERROR- '||SQLERRM);
                  End; -- Excecao da Finalizadora
                  If R1.SITUACAO_CAPA IN (2, 9) Then
                     -- danilo 67039 - Econ -- Quando o Cupom e cancelado no meio do processo nao tem finalizadora
                     vTotalFinalizadora := vTotalCapa;
                  End If;
                  If R1.SITUACAO_CAPA IN (2, 9) and (r1.tipo_recebimento = 20) Then
                     --Pagamento de Duplicata
                     vTotalCapa         := 0;
                     vTotalDetalhe      := 0;
                     vTotalFinalizadora := 0;
                  End If;
                  If (((vTotalCapa = vTotalDetalhe) and (vTotalDetalhe = vTotalFinalizadora) and (R1.SITUACAO_CAPA NOT IN (2, 9))) or (R1.SITUACAO_CAPA IN (2, 9))) --Or vPulaDetalhe = 1
                   Then
                     if intUtilizaMPBem = 1 then
                        /*Caso 3529 */
                        begin
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4343, 'PRC_CUPOM_MP_BEM');
                           PRC_CUPOM_MP_BEM(r1.data_venda, intCodigoLoja, r1.numero_pdv, r1.numero_cupom);
                        Exception
                           when others Then
                              RollBack;
                              vErro          := 'Erro ao verificar regras do MP do BEM. Capa Cupom - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                              strErroDetalhe := 'Erro ao verificar regras do MP do BEM. Capa Cupom - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                              -- prc_raiseapplication('Erro');
                              --Tratamento para deixar somente o ultimo log de um cupom
                              -- Danilo 04/07/2013
                              DELETE FROM LOG_IMPORTACAO
                               WHERE DATA = R1.DATA_VENDA
                                 AND LOJA = r1.Numero_loja
                                 AND PDV = R1.NUMERO_PDV
                                 AND CUPOM = R1.NUMERO_CUPOM
                                 AND CONECTO = 1;
                              BEGIN
                                 SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                              EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                    vCont := 0;
                              END;
                              IF vCont = 0 THEN
                                 strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                 UPDATE EMPORIUM.EXPDET_SALE ES
                                    SET ES.STATUS = 3
                                  WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                    AND ES.STORE_KEY = R1.NUMERO_LOJA
                                    AND ES.POS_NUMBER = R1.NUMERO_PDV
                                    AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                 INSERT INTO LOG_IMPORTACAO
                                    (CHAVE
                                    ,REGISTRO
                                    ,TABELA
                                    ,ERROBANCO
                                    ,VERIFICADO
                                    ,DATA
                                    ,LOJA
                                    ,PDV
                                    ,CUPOM
                                    ,CONECTO
                                    ,ERROBANCO_DETALHES)
                                 values
                                    (log_importacao_seq.nextval
                                    ,Substr(vDetalhe, 1, 200)
                                    ,'EMPORIUM.EXPDET_SALE'
                                    ,Substr(vErro, 1, 200)
                                    ,0
                                    ,R1.DATA_VENDA
                                    ,r1.NUMERO_LOJA
                                    ,R1.NUMERO_PDV
                                    ,R1.NUMERO_CUPOM
                                    ,1
                                    ,strErroDetalhe);
                              END IF;
                              commit;
                        End;
                     end if;
                     if (vImportaComissao = 1) and (intcomissaopdv = 1) then
                        begin
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4405, 'PROC_GRAVA_COMISSAO');                                                                  
                           PROC_GRAVA_COMISSAO(intCodigoLoja, r1.numero_cupom, r1.numero_pdv, r1.data_venda);
                        Exception
                           when others Then
                              RollBack;
                              vErro          := 'Erro ao gravar Comissao. Capa Cupom - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                              strErroDetalhe := 'Erro ao gravar Comissao. Capa Cupom - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                              -- prc_raiseapplication('Erro');
                              --Tratamento para deixar somente o ultimo log de um cupom
                              -- Danilo 04/07/2013
                              DELETE FROM LOG_IMPORTACAO
                               WHERE DATA = R1.DATA_VENDA
                                 AND LOJA = r1.Numero_loja
                                 AND PDV = R1.NUMERO_PDV
                                 AND CUPOM = R1.NUMERO_CUPOM
                                 AND CONECTO = 1;
                              BEGIN
                                 SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                              EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                    vCont := 0;
                              END;
                              IF vCont = 0 THEN
                                 strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                 UPDATE EMPORIUM.EXPDET_SALE ES
                                    SET ES.STATUS = 3
                                  WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                    AND ES.STORE_KEY = R1.NUMERO_LOJA
                                    AND ES.POS_NUMBER = R1.NUMERO_PDV
                                    AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                 INSERT INTO LOG_IMPORTACAO
                                    (CHAVE
                                    ,REGISTRO
                                    ,TABELA
                                    ,ERROBANCO
                                    ,VERIFICADO
                                    ,DATA
                                    ,LOJA
                                    ,PDV
                                    ,CUPOM
                                    ,CONECTO
                                    ,ERROBANCO_DETALHES)
                                 values
                                    (log_importacao_seq.nextval
                                    ,Substr(vDetalhe, 1, 200)
                                    ,'EMPORIUM.EXPDET_SALE'
                                    ,Substr(vErro, 1, 200)
                                    ,0
                                    ,R1.DATA_VENDA
                                    ,r1.NUMERO_LOJA
                                    ,R1.NUMERO_PDV
                                    ,R1.NUMERO_CUPOM
                                    ,1
                                    ,strErroDetalhe);
                              END IF;
                              commit;
                        End;
                     end if;
                     -- caso 5803 03/09/2014 - lorran - inicio
                     if (vCapaTotalBruto <> vDetalhesTotalBruto) --And vPulaDetalhe = 0
                      then
                        RollBack;
                        vErro          := 'Divergencia do Total Bruto da Capa com Total dos Detalhes -1 Capa: ' || vCapaTotalBruto || ' - Detalhes: ' || vDetalhesTotalBruto;
                        strErroDetalhe := vErro;
                        strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                        -- prc_raiseapplication('Erro');
                        DELETE FROM LOG_IMPORTACAO
                         WHERE DATA = R1.DATA_VENDA
                           AND LOJA = r1.Numero_loja
                           AND PDV = R1.NUMERO_PDV
                           AND CUPOM = R1.NUMERO_CUPOM
                           AND CONECTO = 1;
                        UPDATE EMPORIUM.EXPDET_SALE ES
                           SET ES.STATUS = 3
                         WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                           AND ES.STORE_KEY = R1.NUMERO_LOJA
                           AND ES.POS_NUMBER = R1.NUMERO_PDV
                           AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                        INSERT INTO LOG_IMPORTACAO
                           (CHAVE
                           ,REGISTRO
                           ,TABELA
                           ,ERROBANCO
                           ,VERIFICADO
                           ,DATA
                           ,LOJA
                           ,PDV
                           ,CUPOM
                           ,CONECTO
                           ,ERROBANCO_DETALHES)
                        values
                           (log_importacao_seq.nextval
                           ,Substr(vDetalhe, 1, 200)
                           ,'EMPORIUM.EXPDET_SALE'
                           ,Substr(vErro, 1, 200)
                           ,0
                           ,R1.DATA_VENDA
                           ,r1.NUMERO_LOJA
                           ,R1.NUMERO_PDV
                           ,R1.NUMERO_CUPOM
                           ,1
                           ,strErroDetalhe);
                        commit;
                     end if;
                     -- caso 5803 03/09/2014 - lorran - final
                     /*Caso - 4619 -- Danilo - 06/11/2013 -- inicio*/
                     if intPreVendaVinculo > 0 and 1 = 1 then
                        BEGIN
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4514, 'PEDIDOS/OPERACOES_1');                                                            
                           SELECT COUNT(*)
                             into vCont
                             FROM PEDIDOS     P
                                 ,OPERACOES_1 OP
                            WHERE P.OPERACAO = OP.CODIGO
                              AND OP.ECOMMERCE = 1
                              AND P.CHAVE = intPreVendaVinculo;
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                              vCont := 0;
                        END;
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4529, 'SOCIN_CAPA_CUPOM');
                        UPDATE SOCIN_CAPA_CUPOM
                           SET ECOMMERCE      = vCont
                              ,PEDIDO_SUPERUS = intPreVendaVinculo
                         WHERE DATA = R1.DATA_VENDA
                           AND LOJA = intCodigoLoja
                           AND PDV = R1.NUMERO_PDV
                           AND CUPOM = R1.NUMERO_CUPOM;
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                           
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;              
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4539, 'pedidos_referencia_cupom_nf');   
                        delete from pedidos_referencia_cupom_nf pr
                         where pr.chavepedido = intPreVendaVinculo
                           and pr.data = R1.DATA_VENDA
                           and pr.cupom_loja = intCodigoLoja
                           and pr.cupom_pdv = r1.numero_pdv
                           and pr.cupom_cupom = r1.numero_cupom;
                        if (R1.SITUACAO_CAPA NOT IN (2, 9)) then
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                        
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4549, 'pedidos_referencia_cupom_nf');                                              
                           insert into pedidos_referencia_cupom_nf
                              (chavepedido
                              ,chavepedidonf
                              ,data
                              ,cupom_loja
                              ,cupom_pdv
                              ,cupom_cupom
                              ,chave
                              ,valor)
                           values
                              (intPreVendaVinculo
                              ,0
                              ,R1.DATA_VENDA
                              ,intCodigoLoja
                              ,r1.numero_pdv
                              ,r1.numero_cupom
                              ,pedidos_referencia_cupomnf_seq.nextval
                              ,vTotalCapa);
                        end if;
                     end if;

                     --Caso 35165 - Caio Guelre - 21/03/2024
                     --PROCURA PRIMEIRO SE É UM PRÉ-CADASTRO
                     --SE FOR, VERIFICA SE O CPF CONTÉM 11 DÍGITOS E SE NÃO EXISTE NA TABELA DE FIDELIDADE
                     --TAMANHO DO TELEFONE E CFP: 11 DÍGITOS, SE FOR DIFERENTE ESTÁ ERRADO
                     BEGIN
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                  
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4578, 'EMPORIUM.EXPDET_ANSWER_DATA');
                        SELECT E.DATA_VALUE
                          INTO strTelefoneClienteFidelidade
                          FROM EMPORIUM.EXPDET_ANSWER_DATA E
                         WHERE E.STORE_KEY = R1.NUMERO_LOJA
                           AND E.POS_NUMBER = R1.NUMERO_PDV
                           AND E.TICKET_NUMBER = R1.NUMERO_CUPOM
                           AND E.DATA_ID IN (13) --TELEFONE
                           AND LENGTH(E.DATA_VALUE) = 11
                           AND TRUNC(E.START_TIME) = R1.DATA_VENDA;
                     EXCEPTION
                          WHEN OTHERS THEN
                               strTelefoneClienteFidelidade := NULL;
                     END;

                     IF strTelefoneClienteFidelidade IS NOT NULL THEN
                        BEGIN
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                  
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4597, 'EMPORIUM.EXPDET_ANSWER_DATA');
                           SELECT E.DATA_VALUE
                             INTO strCPFClienteFidelidade
                             FROM EMPORIUM.EXPDET_ANSWER_DATA E
                            WHERE E.STORE_KEY = R1.NUMERO_LOJA
                              AND E.POS_NUMBER = R1.NUMERO_PDV
                              AND E.TICKET_NUMBER = R1.NUMERO_CUPOM
                              AND E.DATA_ID IN (491) --CPF
                              AND LENGTH(E.DATA_VALUE) = 11
                              AND TRUNC(E.START_TIME) = R1.DATA_VENDA;
                        EXCEPTION
                             WHEN OTHERS THEN
                                  strCPFClienteFidelidade := NULL;
                        END;
                        IF strCPFClienteFidelidade IS NOT NULL THEN
                           BEGIN
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                  
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4615, 'VERDEMAR.CLIENTES_FIDELIDADE');
                              SELECT COUNT(*)
                                INTO intContador
                                FROM VERDEMAR.CLIENTES_FIDELIDADE CF
                               WHERE CF.CPF = strCPFClienteFidelidade;
                           EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                     intContador := 0;
                           END;
                           BEGIN
                              IF intContador > 0 THEN
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                   
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4628, 'VERDEMAR.CLIENTES_FIDELIDADE');
                                 UPDATE VERDEMAR.CLIENTES_FIDELIDADE C
                                    SET C.CELULAR = strTelefoneClienteFidelidade
                                       ,C.PRE_CADASTRO = 1
                                       ,C.ACEITEMEUVERDEMAR = 1
                                       ,C.DATAACEITEMEUVERDEMAR = R1.HORA_VENDA
                                       ,C.DATAULTIMAALTERACAO = SYSDATE
                                  WHERE C.CPF = strCPFClienteFidelidade
                                    AND C.ACEITEMEUVERDEMAR = 0
                                    AND C.PRE_CADASTRO = 0;
                              ELSE
                                 /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                   
                                 PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                                 PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4641, 'VERDEMAR.CLIENTES_FIDELIDADE');
                                 INSERT INTO VERDEMAR.CLIENTES_FIDELIDADE
                                    (CHAVE
                                    ,CPF
                                    ,CELULAR
                                    ,PRE_CADASTRO
                                    ,DATA_CRIACAO)
                                 VALUES
                                    (VERDEMAR.CLIENTES_FIDELIDADE_SEQ.NEXTVAL
                                    ,strCPFClienteFidelidade
                                    ,strTelefoneClienteFidelidade
                                    ,1
                                    ,R1.HORA_VENDA);
                              END IF;
                           EXCEPTION
                                WHEN OTHERS THEN
                                     vErro          := 'Erro ao inserir/alterar os dados do cliente campanha. CPF: ' || strCPFClienteFidelidade || ' - Telefone: ' || strTelefoneClienteFidelidade;
                                     strErroDetalhe := vErro;
                                     strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                                     UPDATE EMPORIUM.EXPDET_SALE ES
                                        SET ES.STATUS = 3
                                      WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                                        AND ES.STORE_KEY = R1.NUMERO_LOJA
                                        AND ES.POS_NUMBER = R1.NUMERO_PDV
                                        AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                                     INSERT INTO LOG_IMPORTACAO
                                        (CHAVE
                                        ,REGISTRO
                                        ,TABELA
                                        ,ERROBANCO
                                        ,VERIFICADO
                                        ,DATA
                                        ,LOJA
                                        ,PDV
                                        ,CUPOM
                                        ,CONECTO
                                        ,ERROBANCO_DETALHES)
                                     VALUES
                                        (LOG_IMPORTACAO_SEQ.NEXTVAL
                                        ,SUBSTR(vDetalhe, 1, 200)
                                        ,'CLIENTES_FIDELIDADE'
                                        ,SUBSTR(vErro, 1, 200)
                                        ,0
                                        ,R1.DATA_VENDA
                                        ,R1.NUMERO_LOJA
                                        ,R1.NUMERO_PDV
                                        ,R1.NUMERO_CUPOM
                                        ,1
                                        ,strErroDetalhe);
                                     COMMIT;
                           END;
                        END IF;
                     END IF;
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                   
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4696, 'prc_clientes_campanha');
                     prc_clientes_campanha(r1.data_venda, intCodigoLoja, r1.numero_pdv, r1.numero_cupom);

                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                            
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4701, 'prc_valida_subida_cupom');
                     prc_valida_subida_cupom(r1.data_venda, intCodigoLoja, r1.numero_pdv, r1.numero_cupom, r1.hora_venda, nvl(vNumero_Cpf_Cnpj, 0)); -- Danilo 04/09/2023
                     BEGIN
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                            
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4706, 'EMPORIUM.EXPDET_SALE_NFCE');
                        SELECT COUNT(*)
                          into vCont
                          FROM EMPORIUM.EXPDET_SALE_NFCE NFCE
                         WHERE TRUNC(NFCE.EMIT_DATE) <= (SYSDATE - 30)
                           AND NFCE.STORE_KEY = R1.NUMERO_LOJA
                           AND NFCE.POS_NUMBER = R1.NUMERO_PDV
                           AND NFCE.TICKET_NUMBER = R1.NUMERO_CUPOM
                           AND TRUNC(NFCE.START_TIME) = TRUNC(R1.DATA_VENDA);
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           vCont := 0;
                     END;
                     IF (vCont > 1) THEN
                        vErro := 'Mais de uma nota para o mesmo cupom na tabela: EMPORIUM.EXPDET_SALE';
                        PRC_RAISEAPPLICATION('Mais de uma nota para o mesmo cupom na tabela:  EXPDET_SALE_NFCE '|| '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                     END IF;
                     BEGIN
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                            
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4726, 'SOCIN_MOV_NFC');
                        SELECT count(*)
                          into vCont
                          FROM SOCIN_MOV_NFC C
                         WHERE C.data >= trunc(sysdate - 30)
                           and c.pdv = R1.NUMERO_PDV
                           and c.num_loj = R1.NUMERO_LOJA
                           and c.cupom <> R1.NUMERO_CUPOM
                           and c.num_lot = (SELECT NFCE_NUMBER
                                              FROM EXPDET_SALE_NFCE A
                                             WHERE TRUNC(A.START_TIME) = TRUNC(R1.DATA_VENDA)
                                               AND A.STORE_KEY = R1.NUMERO_LOJA
                                               AND A.POS_NUMBER = R1.NUMERO_PDV
                                               AND A.TICKET_NUMBER = R1.NUMERO_CUPOM
                                               and a.nfce_key is not null
                                               and r1.Situacao_Capa <> 2 -- Cancelado  - add por danilo -- 06/10/2023
                                            );
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           vCont := 0;
                     END;
                     IF (vCont > 0) THEN
                        vErro := 'Tabela já tem nota com o mesmo número com loja, pdv iguais: EXPDET_SALE_NFCE';
                        PRC_RAISEAPPLICATION('Tabela já tem nota com o mesmo número com loja, pdv iguais: EXPDET_SALE_NFCE '|| '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                     END IF;
                     --VERIFICA SE TEM REGISTRO NA SOCIN_MOV_NFC - CONTROLE SUPERUS
                     BEGIN
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4755, 'SOCIN_MOV_NFC');
                        SELECT COUNT(*)
                          INTO vCont
                          FROM SOCIN_MOV_NFC
                         WHERE LOJA = intCodigoLoja
                           AND DATA = R1.DATA_VENDA
                           AND PDV = R1.NUMERO_PDV
                           AND CUPOM = R1.NUMERO_CUPOM;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           vCont := 0;
                     END;
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4770, 'EMPORIUM.EXPDET_SALE_NFCE');
                     -- Trava para travar cupons sem informac es da Nota, provavelmente vamos ter que tratar cancelados.
                     SELECT COUNT(*)
                       INTO vContNfce
                       FROM EMPORIUM.EXPDET_SALE_NFCE NFCE
                      WHERE TRUNC(NFCE.START_TIME) = TRUNC(R1.DATA_VENDA)
                        AND NFCE.STORE_KEY = R1.NUMERO_LOJA
                        AND NFCE.POS_NUMBER = R1.NUMERO_PDV
                        AND NFCE.TICKET_NUMBER = R1.NUMERO_CUPOM;
                     IF (vContNfce = 0 and intIntegracaoERP <> 5) --And vPulaDetalhe = 0
                      THEN
                        vErro := 'Tabela sem informac es: EXPDET_SALE_NFCE';
                        PRC_RAISEAPPLICATION('Tabela sem informac?es: EXPDET_SALE_NFCE '|| '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela );
                     END IF;
                     --CASO NAO EXISTA, ANTES DE DELETAR, INSERE O QUE TEM NA TABELA DA BASE COMUM
                     IF vCont = 0 and r1.Situacao_Capa <> 2 THEN
                        BEGIN
                           /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                           PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                           PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4788, 'EMPORIUM.EXPDET_SALE_NFCE');
                           SELECT COUNT(*)
                             into vCont
                             FROM EXPDET_SALE_NFCE A
                            WHERE TRUNC(A.START_TIME) = TRUNC(R1.DATA_VENDA)
                              AND A.STORE_KEY = R1.NUMERO_LOJA
                              AND A.POS_NUMBER = R1.NUMERO_PDV
                              AND A.TICKET_NUMBER = R1.NUMERO_CUPOM
                              AND LENGTH(A.NFCE_KEY) < 44;
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                              vCont := 0;
                        END;
                        IF (vCont > 0) THEN
                           vErro := 'Chave de acesso menor do que 44 dígitos na tabela EXPDET_SALE_NFCE.';
                           PRC_RAISEAPPLICATION('Chave de acesso menor do que 44 dígitos na tabela EXPDET_SALE_NFCE. '|| '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                        END IF;
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4808, 'EMPORIUM.EXPDET_SALE_NFCE');
                        --Valida se existe um registro de NFCE igual para cupom diferente
                        FOR c_NFCE IN (SELECT STORE_KEY
                                             ,POS_NUMBER
                                             ,NFCE_NUMBER
                                             ,TICKET_NUMBER
                                         FROM EMPORIUM.EXPDET_SALE_NFCE C
                                        WHERE TRUNC(C.START_TIME) = TRUNC(R1.DATA_VENDA)
                                          AND C.STORE_KEY = R1.NUMERO_LOJA
                                          AND C.POS_NUMBER = R1.NUMERO_PDV
                                          AND C.TICKET_NUMBER = R1.NUMERO_CUPOM)
                        LOOP
                           BEGIN
                              /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                              PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                              PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4822, 'SOCIN_MOV_NFC');
                              SELECT COUNT(*)
                                INTO vCont
                                FROM SOCIN_MOV_NFC S
                               WHERE S.NUM_LOJ = c_NFCE.STORE_KEY
                                 AND S.PDV = c_NFCE.POS_NUMBER
                                 AND S.NUM_LOT = c_NFCE.NFCE_NUMBER
                                 AND S.CUPOM <> c_NFCE.TICKET_NUMBER;
                           EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                 vCont := 0;
                           END;
                           IF (vCont > 0) THEN
                              vErro := 'Já existe o mesmo número de lote para outro cupom, com a mesma loja e pdv (SOCIN_MOV_NFC). Verifique!';
                              PRC_RAISEAPPLICATION('Já existe o mesmo número de lote para outro cupom, com a mesma loja e pdv (SOCIN_MOV_NFC). Verifique! ' || '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                           END IF;
                        END LOOP;
                        --Caso 33855 - Caio Guelre - 24/11/2023
                        /*BEGIN
                           SELECT COUNT(*)
                             into vCont
                             FROM EXPDET_SALE_NFCE A
                            WHERE TRUNC(A.START_TIME) = TRUNC(R1.DATA_VENDA)
                              AND A.STORE_KEY = R1.NUMERO_LOJA
                              AND A.POS_NUMBER = R1.NUMERO_PDV
                              AND A.TICKET_NUMBER = R1.NUMERO_CUPOM
                              AND NVL(A.SEFAZ_STATUS,0) = 0 OR A.NFCE_PROTOCOL IS NULL OR A.NFCE_KEY IS NULL;
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                              vCont := 0;
                        END;
                        IF (vCont > 0) THEN
                           vErro := 'Dados da NFC-e inválidos (Chave de acesso nula, protocolo nulo ou código da Sefaz zerado). Verifique!';
                           PRC_RAISEAPPLICATION('Dados da NFC-e inválidos (Chave de acesso nula, protocolo nulo ou código da Sefaz zerado). Verifique!');
                        END IF;*/
                        -- Cancelado  - add por danilo -- 06/10/2023
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4860, 'SOCIN_MOV_NFC');
                        INSERT INTO SOCIN_MOV_NFC -- Henrique - 22/09
                           (DATA
                           ,LOJA
                           ,PDV
                           ,CUPOM
                           ,NUM_LOJ
                           ,NUM_NFC
                           ,SRE_NFC
                           ,SEQ
                           ,OPE
                           ,NUM_PDV
                           ,TIP_EMS
                           ,NUM_LOT
                           ,DAT_HOR_EMS
                           ,DAT_HOR_RCB
                           ,DAT_HOR_CTG
                           ,CHV_ACS
                           ,DGT_VLR
                           ,NUM_PTC
                           ,NUM_RCB
                           ,AMB
                           ,COD_SFZ
                           ,MSG_SFZ
                           ,MTV_SFZ
                           ,XML_ENV
                           ,XML_RET
                           ,SIT_ENV_NFC
                           ,MTV_CTG
                           ,DAT_HOR_ULT_ENV
                           ,QTD_ENV_NFC
                           ,COD_RET_NFC
                           ,COD_ERR_NFC
                           ,MSG_ERR_NFC
                           ,SIT_INT
                           ,MTV_ERR_INT
                           ,QRCODE
                           ,VRS_LAY_NFC
                           ,DATA_INCLUSAO
                           ,DATA_ALTERACAO)
                           SELECT TRUNC(START_TIME)
                                 ,FNC_CODIGOLOJA(STORE_KEY)
                                 ,POS_NUMBER
                                 ,TICKET_NUMBER
                                 ,STORE_KEY
                                 ,TICKET_NUMBER
                                 ,101
                                 ,1
                                 ,102
                                 ,POS_NUMBER
                                 ,1
                                 ,NFCE_NUMBER
                                 ,EMIT_DATE
                                 ,PROTOCOL_DATE
                                 ,NULL
                                 ,NFCE_KEY
                                 ,NULL
                                 ,NFCE_PROTOCOL
                                 ,NFCE_STATUS
                                 ,1
                                 ,SEFAZ_STATUS
                                 ,'Autorizado o uso da NF-e'
                                 ,'Autorizado o uso da NF-e'
                                 ,NULL
                                 ,NULL
                                 ,2
                                 ,0
                                 ,EMIT_DATE
                                 ,1
                                 ,1
                                 ,0
                                 ,'SUCESSO'
                                 ,NULL
                                 ,NULL
                                 ,NULL
                                 ,NULL
                                 ,SYSDATE
                                 ,NULL
                             FROM EMPORIUM.EXPDET_SALE_NFCE C
                            WHERE TRUNC(C.START_TIME) = TRUNC(R1.DATA_VENDA) --PARA NÃO PRECISAR FAZER TRUNC NA TABELA
                              AND C.STORE_KEY = R1.NUMERO_LOJA
                              AND C.POS_NUMBER = R1.NUMERO_PDV
                              AND C.TICKET_NUMBER = R1.NUMERO_CUPOM;
                     END IF;

                     --Caso .... - Caio - 10/10/2025
                     BEGIN
                        SELECT NVL(SUM(SDC.TOTAL),0)
                          INTO fltTotalTaxas
                          FROM SOCIN_DETALHES_CUPOM SDC
                              ,PRODUTOS PROD
                         WHERE SDC.CODIGO = PROD.CODIGO
                           AND SDC.DATA = TRUNC(R1.DATA_VENDA)
                           AND SDC.LOJA = intCodigoLoja
                           AND SDC.PDV = R1.NUMERO_PDV
                           AND SDC.CUPOM = R1.NUMERO_CUPOM
                           AND SDC.SITUACAO = 'P'
                           AND PROD.DESCONSIDERAR_VENDA_DRE = 1;
                     EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                               fltTotalTaxas := 0;
                     END;

                     IF fltTotalTaxas > 0 THEN
                        UPDATE SOCIN_CAPA_CUPOM
                           SET TOTAL_TAXAS = fltTotalTaxas
                         WHERE DATA = R1.DATA_VENDA
                           AND LOJA = intCodigoLoja
                           AND PDV = R1.NUMERO_PDV
                           AND CUPOM = R1.NUMERO_CUPOM;
                     END IF;

                     IF vErro IS NULL THEN
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4947, 'EMPORIUM.EXPDET_SALE');
                        UPDATE EMPORIUM.EXPDET_SALE ES
                           SET ES.STATUS = 2
                         WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                           AND ES.STORE_KEY = R1.NUMERO_LOJA
                           AND ES.POS_NUMBER = R1.NUMERO_PDV
                           AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                        DELETE FROM LOG_IMPORTACAO
                         WHERE DATA = R1.DATA_VENDA
                           AND LOJA = R1.NUMERO_LOJA
                           AND PDV = R1.NUMERO_PDV
                           AND CUPOM = R1.NUMERO_CUPOM
                           AND CONECTO = 1;
                     END IF;
                  Else
                     Rollback;
                     --prc_raiseapplication('Erro');
                     If vLogImp = 'N' Then
                        --Tratamento para deixar somente o ultimo log de um cupom
                        DELETE FROM LOG_IMPORTACAO
                         WHERE DATA = R1.DATA_VENDA
                           AND LOJA = r1.Numero_loja
                           AND PDV = R1.NUMERO_PDV
                           AND CUPOM = R1.NUMERO_CUPOM
                           AND CONECTO = 1;
                        --Quando houver qualquer divergencia de valores do cupom, sera feito o controle na Log_Importacao - Caio Guelre - 24-07-2010
                        If vTotalCapa <> vTotalDetalhe Then
                           vErro          := 'Divergencia do Total da Capa com Total dos Detalhes - Capa: ' || vTotalCapa || ' - Detalhes: ' || vTotalDetalhe;
                           strErroDetalhe := vErro;
                           strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                           UPDATE EMPORIUM.EXPDET_SALE ES
                              SET ES.STATUS = 3
                            WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                              AND ES.STORE_KEY = R1.NUMERO_LOJA
                              AND ES.POS_NUMBER = R1.NUMERO_PDV
                              AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                           Insert into log_importacao
                              (chave
                              ,registro
                              ,tabela
                              ,errobanco
                              ,verificado
                              ,DATA
                              ,LOJA
                              ,PDV
                              ,CUPOM
                              ,CONECTO
                              ,ERROBANCO_DETALHES)
                           values
                              (log_importacao_seq.nextval
                              ,SubStr(vDetalhe, 1, 200)
                              ,'DIVERGENCIA'
                              ,Substr(vErro, 1, 200)
                              ,0
                              ,R1.DATA_VENDA
                              ,R1.NUMERO_LOJA
                              ,R1.NUMERO_PDV
                              ,R1.NUMERO_CUPOM
                              ,1
                              ,strErroDetalhe);
                           Commit;
                        ElsIf vTotalCapa <> vTotalFinalizadora Then
                           if intPreVenda > 0 or intPreVendaVinculo > 0 then
                              strMsmErroAdiciona := strMsmErroAdiciona || ' Pré-venda. Lembre-se de olhar as tabelas do e-commerce ';
                           end if;

                           vErro          := 'Divergencia do Total da Capa com Total da Finalizadora - Capa: ' || vTotalCapa || ' - Finalizadora: ' || vTotalFinalizadora || strMsmErroAdiciona;
                           strErroDetalhe := vErro;
                           strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                           UPDATE EMPORIUM.EXPDET_SALE ES
                              SET ES.STATUS = 3
                            WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                              AND ES.STORE_KEY = R1.NUMERO_LOJA
                              AND ES.POS_NUMBER = R1.NUMERO_PDV
                              AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                           INSERT INTO LOG_IMPORTACAO
                              (CHAVE
                              ,REGISTRO
                              ,TABELA
                              ,ERROBANCO
                              ,VERIFICADO
                              ,DATA
                              ,LOJA
                              ,PDV
                              ,CUPOM
                              ,CONECTO
                              ,ERROBANCO_DETALHES)
                           values
                              (log_importacao_seq.nextval
                              ,Substr(vDetalhe, 1, 200)
                              ,'DIVERGENCIA'
                              ,Substr(vErro, 1, 200)
                              ,0
                              ,
                               --                      R1.DATA_VENDA, intCodigoLoja, R1.NUMERO_PDV, R1.NUMERO_CUPOM);
                               R1.DATA_VENDA
                              ,R1.NUMERO_LOJA
                              ,R1.NUMERO_PDV
                              ,R1.NUMERO_CUPOM
                              ,1
                              ,strErroDetalhe);
                           Commit;
                        ElsIf vTotalDetalhe <> vTotalFinalizadora Then
                           vErro          := 'Divergencia do Total dos Detalhes com Total da Finalizadora - Detalhes: ' || vTotalDetalhe || ' - Finalizadora: ' || vTotalFinalizadora;
                           strErroDetalhe := vErro;
                           strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                           UPDATE EMPORIUM.EXPDET_SALE ES
                              SET ES.STATUS = 3
                            WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                              AND ES.STORE_KEY = R1.NUMERO_LOJA
                              AND ES.POS_NUMBER = R1.NUMERO_PDV
                              AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                           INSERT INTO LOG_IMPORTACAO
                              (CHAVE
                              ,REGISTRO
                              ,TABELA
                              ,ERROBANCO
                              ,VERIFICADO
                              ,DATA
                              ,LOJA
                              ,PDV
                              ,CUPOM
                              ,CONECTO
                              ,ERROBANCO_DETALHES)
                           values
                              (log_importacao_seq.nextval
                              ,Substr(vDetalhe, 1, 200)
                              ,'DIVERGENCIA'
                              ,Substr(vErro, 1, 200)
                              ,0
                              ,R1.DATA_VENDA
                              ,R1.NUMERO_LOJA
                              ,R1.NUMERO_PDV
                              ,R1.NUMERO_CUPOM
                              ,1
                              ,strErroDetalhe);
                           Commit;
                        ElsIf (vCapaTotalBruto <> vDetalhesTotalBruto) --And vPulaDetalhe = 0
                         Then
                           vErro          := 'Divergencia do Total Bruto da Capa com Total dos Detalhes - Capa: ' || vCapaTotalBruto || ' - Detalhes: ' || vDetalhesTotalBruto;
                           strErroDetalhe := vErro;
                           strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                           UPDATE EMPORIUM.EXPDET_SALE ES
                              SET ES.STATUS = 3
                            WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                              AND ES.STORE_KEY = R1.NUMERO_LOJA
                              AND ES.POS_NUMBER = R1.NUMERO_PDV
                              AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                           INSERT INTO LOG_IMPORTACAO
                              (CHAVE
                              ,REGISTRO
                              ,TABELA
                              ,ERROBANCO
                              ,VERIFICADO
                              ,DATA
                              ,LOJA
                              ,PDV
                              ,CUPOM
                              ,CONECTO
                              ,ERROBANCO_DETALHES)
                           values
                              (log_importacao_seq.nextval
                              ,Substr(vDetalhe, 1, 200)
                              ,'DIVERGENCIA'
                              ,Substr(vErro, 1, 200)
                              ,0
                              ,R1.DATA_VENDA
                              ,R1.NUMERO_LOJA
                              ,R1.NUMERO_PDV
                              ,R1.NUMERO_CUPOM
                              ,1
                              ,strErroDetalhe);
                           Commit;
                           -- caso 5803 03/09/2014 - lorran - final
                        End If;
                     End If;
                  End If;
               else
                  -- Caso 32313 - L zaro - 27/06/2023
                  If NVL(r1.tipo_capa, 0) <> 127 Then
                     vErro          := 'O PDV não possui cadastro na loja de venda. Verifique!';
                     strErroDetalhe := vErro;
                     strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                     --Tratamento para deixar somente o ultimo log de um cupom
                     -- Danilo 04/07/2013
                     DELETE FROM LOG_IMPORTACAO
                      WHERE DATA = R1.DATA_VENDA
                        AND LOJA = r1.Numero_loja
                        AND PDV = R1.NUMERO_PDV
                        AND CUPOM = R1.NUMERO_CUPOM
                        AND CONECTO = 1;
                     UPDATE EMPORIUM.EXPDET_SALE ES
                        SET ES.STATUS = 3
                      WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                        AND ES.STORE_KEY = R1.NUMERO_LOJA
                        AND ES.POS_NUMBER = R1.NUMERO_PDV
                        AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM;
                     INSERT INTO LOG_IMPORTACAO
                        (CHAVE
                        ,REGISTRO
                        ,TABELA
                        ,ERROBANCO
                        ,VERIFICADO
                        ,DATA
                        ,LOJA
                        ,PDV
                        ,CUPOM
                        ,CONECTO
                        ,ERROBANCO_DETALHES)
                     values
                        (log_importacao_seq.nextval
                        ,Substr(vDetalhe, 1, 200)
                        ,'CADASTROLOJA'
                        ,Substr(vErro, 1, 200)
                        ,0
                        ,
                         --                R1.DATA_VENDA, intCodigoLoja, R1.NUMERO_PDV, R1.NUMERO_CUPOM);
                         R1.DATA_VENDA
                        ,r1.NUMERO_LOJA
                        ,R1.NUMERO_PDV
                        ,R1.NUMERO_CUPOM
                        ,1
                        ,strErroDetalhe);
                     commit;
                  End If;
               End If; --Final do IF do vINSEREPDV
            Exception
               when others Then
                  --raise_application_error(-20001,'Erro ao Importar Cupom - Cupom->'||r1.numero_cupom||' '||SQLCODE||' -ERROR- '||SQLERRM);
                  RollBack;
                  --           null;
                  vErro          := 'Erro ao Importar Capa Cupom - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                  strErroDetalhe := 'Erro ao Importar Capa Cupom - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                  strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                  --Tratamento para deixar somente o ultimo log de um cupom
                  -- Danilo 04/07/2013
                  DELETE FROM LOG_IMPORTACAO
                   WHERE DATA = R1.DATA_VENDA
                     AND LOJA = r1.Numero_loja
                     AND PDV = R1.NUMERO_PDV
                     AND CUPOM = R1.NUMERO_CUPOM
                     AND CONECTO = 1;
                  BEGIN
                     SELECT COUNT(*) INTO vCont FROM TB_FORCAR_IMPORTAR_CUPOM_CONECTO WHERE ERRO LIKE '%' || strErroDetalhe || '%';
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        vCont := 0;
                  END;
                  IF vCont = 0 THEN
                     UPDATE EMPORIUM.EXPDET_SALE ES
                        SET ES.STATUS = 3
                      WHERE TRUNC(ES.START_TIME) = TRUNC(R1.DATA_VENDA)
                        AND ES.STORE_KEY = R1.NUMERO_LOJA
                        AND ES.POS_NUMBER = R1.NUMERO_PDV
                        AND ES.TICKET_NUMBER = R1.NUMERO_CUPOM
                        and es.sale_type = r1.sale_type;
                     INSERT INTO LOG_IMPORTACAO
                        (CHAVE
                        ,REGISTRO
                        ,TABELA
                        ,ERROBANCO
                        ,VERIFICADO
                        ,DATA
                        ,LOJA
                        ,PDV
                        ,CUPOM
                        ,CONECTO
                        ,ERROBANCO_DETALHES)
                     values
                        (log_importacao_seq.nextval
                        ,Substr(vDetalhe, 1, 200)
                        ,'EMPORIUM.EXPDET_SALE'
                        ,Substr(vErro, 1, 200)
                        ,0
                        ,
                         --                  R1.DATA_VENDA, intCodigoLoja, R1.NUMERO_PDV, R1.NUMERO_CUPOM);
                         R1.DATA_VENDA
                        ,r1.NUMERO_LOJA
                        ,R1.NUMERO_PDV
                        ,R1.NUMERO_CUPOM
                        ,1
                        ,strErroDetalhe);
                  END IF;
                  commit;
            End; -- Excecao do Capa
            If ParCommit <= vReg Then
               vReg := 0;
               Commit;
            End If;
         End loop;

         --Caso 35208 - Caio Guelre - 26/03/2024
         --Tratamento para utilizar o valor da alíquota e não o código fixo
         vReg := 0;
         /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                    
         PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
         PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(4860, 'EMPORIUM.EXPDET_GERAL/EMPORIUM.EXPDET_TRIB');
         For r2 in (SELECT trunc(ES_EG.FISCAL_DATE) AS DATA_MOVIMENTO
                          ,ES_EG.STORE_KEY AS NUMERO_LOJA
                          ,ES_EG.POS_NUMBER AS NUMERO_PDV
                          ,ES_EG.AMOUNT_GROSS /* + ES_EG.INCREASE 25/01/2024 - 34466 - Vinícius */ AS VENDA_BRUTA
                          ,ES_EG.VOID AS CANCELADO
                          ,ES_EG.DISCOUNT AS DESCONTO
                          ,SUM(CASE
                                  WHEN ES_ET.POS_ID = 'F' THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS SUBSTITUICAO
                          ,SUM(CASE
                                  WHEN ES_ET.POS_ID = 'I' THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS ISENTO
                          ,SUM(CASE
                                  WHEN ES_ET.POS_ID = 'N' THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS NAO_TRIBUTADO
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa1 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS BASE_IMPOSTO_01
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa2 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS BASE_IMPOSTO_02
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa3 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS BASE_IMPOSTO_03
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa4 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS BASE_IMPOSTO_04
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa5 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS BASE_IMPOSTO_05
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa6 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.AMOUNT
                                  ELSE
                                   0.00
                               END) AS BASE_IMPOSTO_06
                          ,0.00 AS BASE_IMPOSTO_07 -- Não tem
                          ,0.00 AS BASE_IMPOSTO_08 -- Não tem
                          ,0.00 AS BASE_IMPOSTO_09 -- Não tem
                          ,0.00 AS BASE_IMPOSTO_10 -- Não tem
                          ,MAX(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa1 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_PERCENT
                                  ELSE
                                   0
                               END) AS ALIQUOTA_IMPOSTO_01
                          ,MAX(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa2 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_PERCENT
                                  ELSE
                                   0
                               END) AS ALIQUOTA_IMPOSTO_02
                          ,MAX(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa3 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_PERCENT
                                  ELSE
                                   0
                               END) AS ALIQUOTA_IMPOSTO_03
                          ,MAX(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa4 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_PERCENT
                                  ELSE
                                   0
                               END) AS ALIQUOTA_IMPOSTO_04
                          ,MAX(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa5 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_PERCENT
                                  ELSE
                                   0
                               END) AS ALIQUOTA_IMPOSTO_05
                          ,MAX(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa6 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_PERCENT
                                  ELSE
                                   0
                               END) AS ALIQUOTA_IMPOSTO_06
                          ,0.00 AS ALIQUOTA_IMPOSTO_07 -- Não tem
                          ,0.00 AS ALIQUOTA_IMPOSTO_08 -- Não tem
                          ,0.00 AS ALIQUOTA_IMPOSTO_09 -- Não tem
                          ,0.00 AS ALIQUOTA_IMPOSTO_10 -- Não tem
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa1 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_AMOUNT
                                  ELSE
                                   0
                               END) AS VALOR_IMPOSTO_01
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa2 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_AMOUNT
                                  ELSE
                                   0
                               END) AS VALOR_IMPOSTO_02
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa3 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_AMOUNT
                                  ELSE
                                   0
                               END) AS VALOR_IMPOSTO_03
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa4 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_AMOUNT
                                  ELSE
                                   0
                               END) AS VALOR_IMPOSTO_04
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa5 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_AMOUNT
                                  ELSE
                                   0
                               END) AS VALOR_IMPOSTO_05
                          ,SUM(CASE
                                  WHEN ES_ET.TAX_PERCENT = fltAliquotaMapa6 AND ES_ET.POS_ID NOT IN ('F', 'I', 'N') THEN
                                   ES_ET.TAX_AMOUNT
                                  ELSE
                                   0
                               END) AS VALOR_IMPOSTO_06
                          ,0.00 AS VALOR_IMPOSTO_07 -- Não tem
                          ,0.00 AS VALOR_IMPOSTO_08 -- Não tem
                          ,0.00 AS VALOR_IMPOSTO_09 -- Não tem
                          ,0.00 AS VALOR_IMPOSTO_10 -- Não tem
                          ,ES_EG.INITIAL_TICKET AS CONTADOR_INICIAL
                          ,ES_EG.FINISH_TICKET AS CONTADOR_FINAL
                          ,ES_EG.Z_NUMBER AS CONTADOR_REDUCAO
                          ,ES_EG.CRO AS CONTADOR_REINICIO
                          ,0.00 AS NUMERO_RELATORIO
                          ,ES_EG.INITIAL_GT AS GRANDE_TOTAL_INICIAL
                          ,ES_EG.FINAL_GT AS GRANDE_TOTAL_FINAL
                          ,0.00 AS PERC_MFD_REMANESCENTE
                          ,0.00 AS VERSAO_SOFTWARE_BASICO
                      FROM EMPORIUM.EXPDET_GERAL ES_EG
                          ,EMPORIUM.EXPDET_TRIB  ES_ET
                     WHERE ES_ET.POS_NUMBER = ES_EG.POS_NUMBER
                       AND ES_ET.STORE_KEY = ES_EG.STORE_KEY
                       AND ES_ET.FISCAL_DATE = ES_EG.FISCAL_DATE
                       AND ES_EG.STORE_KEY = c_LOJ.NUMEROLOJA --  parLoja
                       AND ((ES_EG.FISCAL_DATE >= TRUNC(SYSDATE) - 0))
                        OR (EXISTS (SELECT 1
                                      FROM REPROCESSO_VENDA R
                                     WHERE R.DATA = ES_EG.FISCAL_DATE
                                       AND R.LOJA = ES_EG.STORE_KEY
                                       AND R.PDV = ES_EG.POS_NUMBER
                                       AND ES_ET.POS_NUMBER = ES_EG.POS_NUMBER
                                       AND ES_ET.STORE_KEY = ES_EG.STORE_KEY
                                       AND ES_ET.FISCAL_DATE = ES_EG.FISCAL_DATE
                                       AND R.LOJA = c_LOJ.NUMEROLOJA
                                       AND R.CUPOM = 0
                                       AND R.MAPARESUMO = 1
                                       AND R.STATUS = 0)) --PROVISÓRIO CAIO - 20/09/2023
                     GROUP BY trunc(ES_EG.FISCAL_DATE)
                             ,ES_EG.STORE_KEY
                             ,ES_EG.POS_NUMBER
                             ,ES_EG.AMOUNT_GROSS
                             ,ES_EG.INCREASE
                             ,ES_EG.VOID
                             ,ES_EG.DISCOUNT
                             ,ES_EG.INITIAL_TICKET
                             ,ES_EG.FINISH_TICKET
                             ,ES_EG.Z_NUMBER
                             ,ES_EG.CRO
                             ,ES_EG.INITIAL_GT
                             ,ES_EG.FINAL_GT
                     ORDER BY 1 ASC)
         LOOP
            Begin
               Begin
                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                          
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5435, 'loja/lojas_pdv');
                  select codigo
                    into intCodigoLoja
                    from loja      l
                        ,lojas_pdv lp
                   where l.codigo = lp.loja
                     and numeroloja = r2.numero_loja
                     and lp.pdv = R2.NUMERO_PDV;
               Exception
                  when no_data_found Then
                     Begin
                        /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                     
                        PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                        PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5448, 'loja/lojas_pdv');
                        select codigo
                          into intCodigoLoja
                          from loja      l
                              ,lojas_pdv lp
                         where l.codigo = lp.loja
                           and lp.pdv = r2.numero_pdv
                           and lp.lojaimportacao = (select lj.codigo
                                                      from loja lj
                                                     where lj.codigo = lp.lojaimportacao
                                                       and lj.numeroloja = r2.numero_loja);
                     Exception
                        when no_data_found Then
                           intCodigoLoja := -1;
                           vInserePdv   := 0;
                     End;
               End;
               vDetalhe := 'Data: ' || r2.data_movimento || ' - Loja: ' || R2.NUMERO_LOJA || ' - PDV: ' || r2.numero_pdv;
               --Caso 15867 - Caio Guelre - 12/05/2017
               IF intCodigoLoja = -1 THEN
                  vDetalhe := vDetalhe || ' - LOJA N O ENCONTRADA';
                  PRC_RAISEAPPLICATION(vDetalhe || '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
               END IF;
               vReg := vReg + 1;
               /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                     
               PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
               PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5474, 'maparesumo');
               Select count(*)
                 into vCont
                 from maparesumo
                where data = r2.data_movimento
                  and loja = intCodigoLoja
                  and pdv = r2.numero_pdv;
               --Caso 18037 - Caio Guelre - 15/01/2018
               vReprocesso := 'S';
               IF vCont > 0 THEN
                  BEGIN
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                 
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5487, 'REPROCESSO_VENDA');
                     SELECT COUNT(*)
                       INTO intRepMaparesumo
                       FROM REPROCESSO_VENDA REP
                      WHERE REP.DATA = r2.DATA_MOVIMENTO
                        AND REP.LOJA = r2.NUMERO_LOJA
                        AND REP.PDV = r2.NUMERO_PDV
                        AND REP.MAPARESUMO = 1;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        intRepMaparesumo := 0;
                  END;
                  IF intRepMaparesumo > 0 THEN
                     vReprocesso := 'S';
                  END IF;
               END IF;
               --IMPORTA SOMENTE SE NAO EXISTIR REGISTRO, OU FOI LIBERADO PELO CRIA SELECT
               IF (vCont > 0) OR (vReprocesso = 'S') THEN
                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                 
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5507, 'maparesumo');
                  Delete from maparesumo
                   where data = r2.data_movimento
                     and loja = intCodigoLoja
                     and pdv = r2.numero_pdv;

                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                                        
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5515, 'socin_maparesumo');
                  Select count(*)
                    into vCont
                    from socin_maparesumo
                   where data = r2.data_movimento
                     and loja = intCodigoLoja
                     and pdv = r2.numero_pdv;

                  If vCont > 0 Then
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                          
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5526, 'socin_maparesumo');
                     Delete from socin_maparesumo
                      where data = r2.data_movimento
                        and loja = intCodigoLoja
                        and pdv = r2.numero_pdv;
                  End If;
                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5534, 'socin_capa_cupom');
                  select count(*)
                    into vCuponsCancelados
                    from socin_capa_cupom
                   where data = r2.data_movimento
                     and loja = intCodigoLoja --Aqui e loja ao inves de número loja, ja que a consulta e em nossa base
                     and pdv = r2.numero_pdv
                     and situacao = '2';

                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5545, 'socin_maparesumo_grava');   
                  socin_maparesumo_grava(r2.aliquota_imposto_04,
                                         intCodigoLoja,
                                         r2.data_movimento,
                                         r2.aliquota_imposto_05,
                                         r2.aliquota_imposto_01,
                                         r2.aliquota_imposto_02,
                                         r2.aliquota_imposto_03,
                                         r2.aliquota_imposto_06,
                                         r2.aliquota_imposto_08,
                                         r2.aliquota_imposto_09,
                                         r2.aliquota_imposto_07,
                                         r2.aliquota_imposto_10,
                                         0, -- ParAliquota11,
                                         0, -- ParAliquota12,
                                         0, -- ParAliquota13,
                                         0, -- ParAliquota14,
                                         0, -- ParAliquota15,
                                         0, -- ParAliquota17,
                                         0, -- ParAliquota18,
                                         0, -- ParAliquota19,
                                         0, -- ParAliquota20,
                                         r2.base_imposto_01, r2.base_imposto_02, r2.base_imposto_03, r2.base_imposto_04, r2.base_imposto_05, r2.base_imposto_06, r2.base_imposto_07, r2.base_imposto_08, r2.base_imposto_09, r2.base_imposto_10, 0, -- ParBase11,
                                         0, -- ParBase12,
                                         0, -- ParBase13,
                                         0, -- ParBase14,
                                         0, -- ParBase15,
                                         0, -- ParBase16,
                                         0, -- ParBase17,
                                         0, -- ParBase18,
                                         0, -- ParBase19,
                                         0, -- ParBase20,
                                         r2.valor_imposto_01, r2.valor_imposto_02, r2.valor_imposto_03, r2.valor_imposto_04, r2.valor_imposto_05, r2.valor_imposto_06, r2.valor_imposto_07, r2.valor_imposto_08, r2.valor_imposto_09, r2.valor_imposto_10, 0, -- ParICMS11,
                                         0, -- ParICMS12,
                                         0, -- ParICMS13,
                                         0, -- ParICMS14,
                                         0, -- ParICMS15,
                                         0, -- ParICMS16,
                                         0, -- ParICMS17,
                                         0, -- ParICMS18,
                                         0, -- ParICMS19,
                                         0, -- ParICMS20,
                                         r2.cancelado, r2.desconto, r2.grande_total_final, r2.grande_total_inicial, r2.isento, r2.nao_tributado, r2.contador_final, r2.contador_inicial, r2.numero_pdv, r2.contador_reducao, r2.numero_relatorio, r2.substituicao, r2.venda_bruta, 0, -- ParAliquota16,
                                         0, -- ParIntervencoes,
                                         vCuponsCancelados, -- ParCuponsCancelados
                                         r2.CONTADOR_REINICIO);

                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5594, 'EMPORIUM.EXPDET_GERAL');                       
                  DELETE FROM EMPORIUM.EXPDET_GERAL ES_EG
                   WHERE TRUNC(ES_EG.FISCAL_DATE) = r2.data_movimento
                     AND ES_EG.STORE_KEY = r2.numero_loja
                     AND ES_EG.POS_NUMBER = r2.numero_pdv;
                  BEGIN
                     /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                     PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                     PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5594, 'MAPARESUMO/MAPARESUMO_IMPOSTOS');
                     SELECT COUNT(*)
                       INTO vCont
                       FROM (SELECT MI.BASE
                                   ,MI.ALIQUOTA
                                   ,MI.VALOR
                                   ,ROUND(MI.BASE * (MI.ALIQUOTA / 100), 2) VALOR_CALC
                               FROM MAPARESUMO          MP
                                   ,MAPARESUMO_IMPOSTOS MI
                              WHERE MI.CHAVEMAPARESUMO = MP.CHAVE
                                AND MP.DATA >= r2.DATA_MOVIMENTO
                                AND MP.DATA < (r2.DATA_MOVIMENTO + 1)
                                AND MP.LOJA = intCodigoLoja
                                AND MP.PDV = r2.NUMERO_PDV
                                AND MI.TIPO = 'T') T
                      WHERE ABS(VALOR - VALOR_CALC) > 0.02;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        vCont := 0;
                  END;
                  IF vCont > 0 THEN
                     vDetalhe := vDetalhe || ' - DIVERGENCIA IMPOSTOS';
                     PRC_RAISEAPPLICATION(vDetalhe || '- Trace Infos Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' Tabela(s)PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela);
                  END IF;

                  /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
                  PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
                  PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5629, 'REPROCESSO_VENDA');
                  -- Caio - 08/03/2024
                  UPDATE REPROCESSO_VENDA R
                     SET STATUS = 1
                   WHERE R.DATA = R2.DATA_MOVIMENTO
                     AND R.LOJA = R2.NUMERO_LOJA
                     AND R.PDV = R2.NUMERO_PDV
                     AND R.CUPOM = 0
                     AND R.STATUS = 0
                     AND R.MAPARESUMO = 1;

                  DELETE FROM LOG_IMPORTACAO
                   WHERE DATA = R2.DATA_MOVIMENTO
                     AND TABELA = 'EMPORIUM.EXPDET_GERAL'
                     AND LOJA = R2.NUMERO_LOJA
                     AND PDV = R2.NUMERO_PDV
                     AND CUPOM = 0
                     AND CONECTO = 1;
               END IF;
               If ParCommit <= vReg Then
                  vReg := 0;
                  Commit;
               End If;
            Exception
               when others then
                  Rollback;
                  vErro          := 'Erro ao Importar Mapa Resumo - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                  strErroDetalhe := 'Erro ao Importar Mapa Resumo - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                  Insert into log_importacao
                     (chave
                     ,registro
                     ,tabela
                     ,errobanco
                     ,verificado
                     ,DATA
                     ,LOJA
                     ,PDV
                     ,CUPOM
                     ,CONECTO
                     ,ERROBANCO_DETALHES)
                  values
                     (log_importacao_seq.nextval
                     ,Substr(vDetalhe, 1, 200)
                     ,'EMPORIUM.EXPDET_GERAL'
                     ,Substr(vErro, 1, 200)
                     ,0
                     ,R2.DATA_MOVIMENTO
                     ,R2.NUMERO_LOJA
                     ,R2.NUMERO_PDV
                     ,0
                     ,1
                     ,strErroDetalhe);
                  commit;
            End;
         End Loop;
         vReg := 0;
         For r2 in (SELECT trunc(exp_m.start_time) as DATA_MOVIMENTO
                          ,exp_m.start_time AS HORA_MOVIMENTO
                          ,exp_m.sequence AS SEQUENCIA
                          ,NVL((select CASHIER_ID
                                 from exppickup_header exp_h
                                where exp_h.store_key = exp_m.store_key
                                  and exp_h.pos_number = exp_m.pos_number
                                  and exp_h.ticket_number = exp_m.ticket_number
                                  and exp_h.start_time = exp_m.start_time), 0) AS CODIGO_OPERADOR
                          ,exp_m.store_key AS NUMERO_LOJA
                          ,exp_m.pos_number AS NUMERO_PDV
                          ,exp_m.ticket_number AS NUMERO_CUPOM
                          ,exp_m.media_id AS CODIGO_FINALIZADORA
                          ,(SELECT NOME FROM FINALIZADORAS WHERE CODIGO = exp_m.media_id) DESC_FINALIZADORA
                          ,(SELECT sum(amount)
                              FROM emporium.exppickup_media exp
                             where exp.store_key = exp_m.store_key
                               and exp.pos_number = exp_m.pos_number
                               and exp_m.start_time = exp.start_time) VALOR_SISTEMA
                          ,(select sum(amount)
                              from (select a.trans_type
                                          ,b.*
                                      from emporium.exppickup_media b
                                      join emporium.exppickup_header a
                                        on (a.store_key = b.store_key and a.pos_number = b.pos_number and a.ticket_number = b.ticket_number and a.start_time = b.start_time)
                                     where b.store_key = exp_m.Store_Key
                                       and b.pos_number = exp_m.Pos_Number
                                       and b.start_time = exp_m.Start_Time
                                       and amount > 0
                                       and a.trans_type = 7) miolo
                             group by trans_type) AS VALOR_SANGRIA
                          ,0 VALOR_DIGITADO
                          ,NVL((select sum(b.amount)
                                 from emporium.exppickup_media b
                                 join emporium.exppickup_header a
                                   on (a.store_key = b.store_key and a.pos_number = b.pos_number and a.ticket_number = b.ticket_number and a.start_time = b.start_time)
                                where b.store_key = exp_m.store_key
                                  and b.pos_number = exp_m.pos_number
                                  and b.start_time = exp_m.Start_Time
                                  and amount > 0
                                  and a.trans_type = 6), 0) AS VALOR_ABERTURA
                          ,NVL((select CASHIER_ID
                                 from exppickup_header exp_h
                                where exp_h.store_key = exp_m.store_key
                                  and exp_h.pos_number = exp_m.pos_number
                                  and exp_h.ticket_number = exp_m.ticket_number
                                  and exp_h.start_time = exp_m.start_time), 0) AS USUARIO_FECHTO_CAIXA
                          ,1 SEQUENCIA_OPERACAO
                          ,0 TIPO_EXECUCAO
                      FROM exppickup_media exp_m
                     WHERE exp_m.STORE_KEY = c_LOJ.Numeroloja
                       AND exp_m.STATUS = 1)
         Loop
            Begin
               Begin
                  select codigo
                    into intCodigoLoja
                    from loja      l
                        ,lojas_pdv lp
                   where l.codigo = lp.loja
                     and numeroloja = r2.numero_loja
                     and lp.pdv = r2.numero_pdv;
               Exception
                  when no_data_found Then
                     Begin
                        select codigo
                          into intCodigoLoja
                          from loja      l
                              ,lojas_pdv lp
                         where l.codigo = lp.loja
                           and lp.pdv = r2.numero_pdv
                           and lp.lojaimportacao = (select lj.codigo
                                                      from loja lj
                                                     where lj.codigo = lp.lojaimportacao
                                                       and lj.numeroloja = r2.numero_loja);
                     Exception
                        when no_data_found Then
                           intCodigoLoja := r2.numero_loja;
                           vInserePdv   := 0;
                     End;
               End;
               vDetalhe := 'Data: ' || r2.data_movimento || ' - Loja: ' || R2.NUMERO_LOJA || ' - PDV: ' || r2.numero_pdv || ' - Cupom: ' || r2.numero_cupom || ' - Final.:' || r2.codigo_finalizadora;
               vReg     := vReg + 1;
               Select count(*)
                 into vCont
                 from fechamento_operador
                where data = r2.data_movimento
                  and loja = r2.numero_loja
                  and pdv = r2.numero_pdv
                  and cupom = r2.numero_cupom
                  and finalizadora = r2.codigo_finalizadora;
               If vCont > 0 Then
                  Delete from fechamento_operador
                   where data = r2.data_movimento
                     and loja = r2.numero_loja
                     and pdv = r2.numero_pdv
                     and cupom = r2.numero_cupom
                     and finalizadora = r2.codigo_finalizadora;
               End If;
               socin_fechamento_operador(r2.Numero_Pdv, r2.numero_cupom, r2.data_movimento, intCodigoLoja, lpad(r2.codigo_operador, 7, 0), r2.codigo_finalizadora, r2.valor_sistema, 0, -- ParTroco
                                         r2.valor_sangria, r2.valor_abertura, --Fundo_Caixa
                                         0, -- ParVale
                                         'N', vRetornoOperador);
               UPDATE EMPORIUM.Exppickup_Media
                  SET STATUS = 2
                WHERE STORE_KEY = R2.NUMERO_LOJA
                  AND POS_NUMBER = R2.NUMERO_PDV
                  AND TICKET_NUMBER = R2.NUMERO_CUPOM
                  AND trunc(START_TIME) = TRUNC(R2.DATA_MOVIMENTO)
                  AND SEQUENCE = R2.SEQUENCIA;
               /* delete from tb_bdc_movi_bati_caixa
               where TRUNC(data_movimento) = r2.data_movimento
                 and numero_loja = r2.numero_loja
                 and numero_pdv = r2.numero_pdv
                 and numero_cupom = r2.numero_cupom
                 and codigo_finalizadora = r2.codigo_finalizadora; */
               If ParCommit <= vReg Then
                  vReg := 0;
                  Commit;
               End If;
            Exception
               when no_data_found Then
                  Rollback;
                  vErro          := 'Erro ao Importar Fechamento Operador - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                  strErroDetalhe := 'Erro ao Importar Fechamento Operador - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
                  strErroDetalhe := strErroDetalhe||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - Linha: ' || PKG_LOG_IMPORTACAO_CONECTO.intLinha || ' - Tabela(s)/PRC: ' || PKG_LOG_IMPORTACAO_CONECTO.strNomeTabela;
                  Insert into log_importacao
                     (chave
                     ,registro
                     ,tabela
                     ,errobanco
                     ,verificado
                     ,DATA
                     ,LOJA
                     ,PDV
                     ,CUPOM
                     ,CONECTO
                     ,ERROBANCO_DETALHES)
                  values
                     (log_importacao_seq.nextval
                     ,SubStr(vDetalhe, 1, 200)
                     ,'exppickup_media'
                     ,Substr(vErro, 1, 200)
                     ,0
                     ,R2.DATA_MOVIMENTO
                     ,R2.NUMERO_LOJA
                     ,R2.NUMERO_PDV
                     ,R2.NUMERO_CUPOM
                     ,1
                     ,strErroDetalhe);
                  commit;
                  --raise_application_error(-20001,'Erro ao Importar Mapa Resumo - '||SQLCODE||' -ERROR- '||SQLERRM);
            End;
         End Loop;
      END LOOP;
      Begin
         Commit;
      Exception
         when others then
            Rollback;
      End;
   END;
   --Caso 6008 - Agnaldo - 24/01/2014 - Controle de log referente a JOB executada, feito para nao rodar em todas as execucas
   If (intstatuslogjob = 9999) then
      /* GABRIEL FONSECA 13/10/2025 - CASO 44068 */                                       
      PKG_LOG_IMPORTACAO_CONECTO.intHabilitaRotina := 1;           
      PKG_LOG_IMPORTACAO_CONECTO.PRC_LOG_IMPORTACAO_GRAVA_TRACE(5854, 'JOB_LOG');
      --Retirado a gravac?o do Log por hora
      INSERT INTO JOB_LOG
      VALUES
         ('CONECTO_IMPORTACAO - INICIO '
         ,dtadatahorainiciallog
         ,''
         ,643);
      INSERT INTO JOB_LOG
      VALUES
         ('CONECTO_IMPORTACAO - FIM'
         ,SYSDATE
         ,''
         ,643);
      COMMIT;
   End if;
END CONECTO_IMPORTACAO_T;