// src/mockData.js

// TIPOS de serviço (se você quiser usar em outra seção, tipo "O que fazemos")
export const serviceTypes = [
  {
    id: 1,
    name: "Obras Rodoviárias",
    description:
      "Terraplenagem, viadutos, contenções, pavimentações e serviços complementares.",
  },
  {
    id: 2,
    name: "Obras Industriais",
    description: "Projetos e execução de obras industriais.",
  },
  {
    id: 3,
    name: "Obras de Saneamento",
    description: "ETA, ETE, elevatórias e adutoras.",
  },
  {
    id: 4,
    name: "Portos e Aeroportos",
    description: "Infraestrutura para portos e aeroportos.",
  },
  {
    id: 5,
    name: "Edificações Civis",
    description: "Edificações residenciais, comerciais e institucionais.",
  },
  {
    id: 6,
    name: "Mineração",
    description: "Obras e estruturas ligadas ao setor de mineração.",
  },
  {
    id: 7,
    name: "Barragens",
    description: "Projetos e execução de barragens.",
  },
];

export const servicesData = [
  {
    id: 1,
    name: "Vale S.A.",
    description:
      "Uma das maiores mineradoras do mundo, referência na produção de minério de ferro e logística.",
    imageUrl: "public/VALE.png",
    link: "https://vale.com/pt",
  },
  {
    id: 2,
    name: "Motiva (antiga CCR)",
    description:
      "Grupo de infraestrutura e mobilidade que atua em concessões de rodovias, mobilidade urbana e aeroportos.",
    imageUrl: "public/motiva.png",
    link: "https://www.motiva.com.br/",
  },
  {
    id: 3,
    name: "Albras Alumínio Brasileiro S.A.",
    description:
      "Produtora de alumínio primário, com forte atuação no mercado nacional e internacional.",
    imageUrl: "public/albras.jpeg",
    link: "https://www.albras.com.br/",
  },
  {
    id: 4,
    name: "AngloGold Ashanti",
    description:
      "Empresa global de mineração de ouro, com operações e projetos em diversos países.",
    imageUrl: "public/anglo.jpeg",
    link: "https://www.anglogoldashanti.com/",
  },
  {
    id: 5,
    name: "Concremat Engenharia e Tecnologia",
    description:
      "Grupo de engenharia que atua em projetos, consultoria e gerenciamento de obras de infraestrutura.",
    imageUrl: "public/CONCREMAT.png",
    link: "https://www.concremat.com.br/",
  },
  {
    id: 6,
    name: "CSN – Companhia Siderúrgica Nacional",
    description:
      "Uma das maiores siderúrgicas do Brasil, com atuação em aço, mineração, cimento e logística.",
    imageUrl: "public/CSN.png",
    link: "https://www.csn.com.br/",
  },
  {
    id: 7,
    name: "EcoRodovias",
    description:
      "Empresa de concessões rodoviárias e logística integrada, responsável por importantes corredores viários.",
    imageUrl: "public/EcoRodovias.png",
    link: "https://www.ecorodovias.com.br/",
  },
  {
    id: 8,
    name: "Everest Empreendimentos",
    description:
      "Empresa do setor de empreendimentos e construção, com atuação em projetos imobiliários e de infraestrutura.",
    imageUrl: "public/everest.jpeg",
    link: "https://www.everestempreendimentos.com/",
  },
  {
    id: 9,
    name: "Rumo",
    description:
      "Operadora logística com foco em ferrovias, terminais e portos, integrando o escoamento da produção em larga escala.",
    imageUrl: "public/Rumo.png",
    link: "https://www.rumolog.com/",
  },
  {
    id: 10,
    name: "Consórcio Minas Mais",
    description:
      "Consórcio ligado a projetos de mineração e infraestrutura, com participação da Gerdau em empreendimentos estratégicos.",
    imageUrl: "public/MINASMAIS.jpeg", // você ajusta o nome do arquivo
    link: "#https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://www.instagram.com/consorciominasgerais/&ved=2ahUKEwjr9uyjtamRAxUsrZUCHfkINd4QFnoECBgQAQ&usg=AOvVaw3E-2xMPtIKjfhL4MpXD-3m", // coloca o link oficial se tiver
  }, {
    id: 11,
    name: "Gerdau",
    description:
      "Uma das maiores produtoras de aço das Américas, com forte presença em construção civil, indústria e infraestrutura.",
    imageUrl: "public/gerdau.png", // você ajusta o nome/caminho do arquivo
    link: "https://www2.gerdau.com/", // se quiser, pode usar "#"
  },



];


export function fetchServicesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar serviços");
      } else {
        resolve(servicesData);
      }
    }, 400);
  });
}

export const enterpriseData = {
  name: "Costa Pinto Engenharia LTDA",
  shortDescription: "Prestação de serviços de Proposta Técnica e Engenharia Civil.",
  description:
    "A Costa Pinto Engenharia LTDA atua na área de construção civil e consultoria em obras de construção pesada, com experiência na elaboração de proposta técnica e plano de trabalho.",
  cnpj: "34.887.466/0001-72",
  address: "Rua José Rothéia, 87 - Paquetá, Belo Horizonte - MG, 31.330-632",
  representative: "Fernando Guimarães Costa Pinto",
  contactEmail: "fernandoguimaraesc811@gmail.com",
  phoneNumber: "(31) 98888-4422",
  whatsappNumber: "5531988884422"

};

export function fetchEnterpriseData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar dados da empresa");
      } else {
        resolve(enterpriseData);
      }
    }, 300);
  });
}

export function fetchHeaderData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar o menu");
      } else {
        resolve([
          { name: "Início", link: "#inicio" },
          { name: "Sobre", link: "#sobre" },
          { name: "Serviços", link: "#servicos" },
          { name: "Portfólio", link: "#portfolio" },
          { name: "Contato", link: "#contato" },
        ]);
      }
    }, 500);
  });
}
// === PORTFÓLIO / ENTREGÁVEIS ===

// Lista inspirada naquele quadro de anexos do documento
export const deliverablesData = [
  {
    id: 1,
    code: "Anexo 01",
    title: "Carta de Apresentação",
    description: "Apresentação institucional da Costa Pinto Engenharia LTDA.",
  },
  {
    id: 2,
    code: "Anexo 02",
    title: "Proposta Técnica",
    description: "Proposta técnica detalhada para execução dos serviços de engenharia.",
  },
  {
    id: 3,
    code: "Anexo 03",
    title: "Cronograma Físico",
    description: "Planejamento físico das etapas da obra e seus prazos.",
  },
  {
    id: 4,
    code: "Anexo 04",
    title: "Plano de Gestão de SMS e Qualidade",
    description: "Plano de Segurança, Meio Ambiente e Qualidade aplicado à obra.",
  },
  {
    id: 5,
    code: "Anexo 05",
    title: "Histogramas de Mão de Obra e Equipamentos",
    description: "Distribuição de equipes e equipamentos ao longo do cronograma.",
  },
  {
    id: 6,
    code: "Anexo 06",
    title: "PIT - Plano de Inspeção e Teste",
    description: "Critérios de inspeção, testes e aceitação dos serviços.",
  },
  {
    id: 7,
    code: "Anexo 08",
    title: "Índices de Produtividade",
    description: "Parâmetros de produtividade utilizados no dimensionamento da obra.",
  },
  {
    id: 8,
    code: "Anexo 09",
    title: "Curva S",
    description: "Curva de acompanhamento físico-financeiro do empreendimento.",
  },
  {
    id: 9,
    code: "Anexo 10",
    title: "Lista de Empresas Subcontratadas",
    description: "Relação de empresas parceiras envolvidas na execução da obra.",
  },
  {
    id: 10,
    code: "Anexo 12",
    title: "Declaração de Vistoria",
    description: "Comprovação de vistoria no local da obra.",
  },
];

export function fetchDeliverablesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar portfólio de entregáveis");
      } else {
        resolve(deliverablesData);
      }
    }, 300);
  });
}

// se quiser tratar TIPO DE OBRAS como “API” também:
export function fetchServiceTypesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar tipos de obras");
      } else {
        resolve(serviceTypes); // já definidos lá em cima
      }
    }, 300);
  });
}

