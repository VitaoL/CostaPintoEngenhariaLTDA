// ==============================
// Serviços - Tipos de obras (usados no Portfólio / chips de tipos de obras)
// ==============================
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


// ================================================
// Empresas de engenharia / construtoras
// onde o Eng. Fernando já atuou diretamente
// (empregadoras / contratantes intermediárias)
// ================================================
export const contractorCompaniesData = [
  {
    id: 1,
    name: "Andrade Gutierrez",
    description: "",
    imageUrl: "/andrade.png",
    link: "https://www.andradegutierrez.com.br/",
  },
  {
    id: 2,
    name: "Engenharia de Obras S.A.",
    description: "",
    imageUrl: "/engenhariadeobras.jpeg",
    link: "",
  },
  {
    id: 3,
    name: "Aterpa",
    description: "",
    imageUrl: "/aterpa.png",
    link: "",
  },
  {
    id: 4,
    name: "Cowan",
    description: "",
    imageUrl: "/cowan.jpeg",
    link: "",
  },
  {
    id: 5,
    name: "Btec Construções",
    description: "",
    imageUrl: "/btec.jpeg",
    link: "",
  },
  {
    id: 6,
    name: "Barbosa Mello (CBM)",
    description: "",
    imageUrl: "/barbosamelo.png",
    link: "",
  },
];

// Fake API: empresas de engenharia / construtoras
export function fetchContractorCompaniesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar empresas de engenharia onde já atuamos");
      } else {
        resolve(contractorCompaniesData);
      }
    }, 400);
  });
}


// ======================================================
// Grandes grupos / clientes finais dos projetos
// (ligados à trajetória profissional do Eng. Fernando)
// ======================================================
export const finalClientsData = [
  {
    id: 1,
    name: "Vale S.A.",
    description:
      "Uma das maiores mineradoras do mundo, referência na produção de minério de ferro e logística.",
    imageUrl: "/VALE.png",
    link: "https://vale.com/pt",
  },
  {
    id: 2,
    name: "Motiva (antiga CCR)",
    description:
      "Grupo de infraestrutura e mobilidade que atua em concessões de rodovias, mobilidade urbana e aeroportos.",
    imageUrl: "/motiva.png",
    link: "https://www.motiva.com.br/",
  },
  {
    id: 3,
    name: "Albras Alumínio Brasileiro S.A.",
    description:
      "Produtora de alumínio primário, com forte atuação no mercado nacional e internacional.",
    imageUrl: "/albras.jpeg",
    link: "https://www.albras.com.br/",
  },
  {
    id: 4,
    name: "AngloGold Ashanti",
    description:
      "Empresa global de mineração de ouro, com operações e projetos em diversos países.",
    imageUrl: "/anglo.jpeg",
    link: "https://www.anglogoldashanti.com/",
  },
  {
    id: 5,
    name: "Concremat Engenharia e Tecnologia",
    description:
      "Grupo de engenharia que atua em projetos, consultoria e gerenciamento de obras de infraestrutura.",
    imageUrl: "/CONCREMAT.png",
    link: "https://www.concremat.com.br/",
  },
  {
    id: 6,
    name: "CSN – Companhia Siderúrgica Nacional",
    description:
      "Uma das maiores siderúrgicas do Brasil, com atuação em aço, mineração, cimento e logística.",
    imageUrl: "/CSN.png",
    link: "https://www.csn.com.br/",
  },
  {
    id: 7,
    name: "EcoRodovias",
    description:
      "Empresa de concessões rodoviárias e logística integrada, responsável por importantes corredores viários.",
    imageUrl: "/EcoRodovias.png",
    link: "https://www.ecorodovias.com.br/",
  },
  {
    id: 8,
    name: "Everest Empreendimentos",
    description:
      "Empresa do setor de empreendimentos e construção, com atuação em projetos imobiliários e de infraestrutura.",
    imageUrl: "/everest.jpeg",
    link: "https://www.everestempreendimentos.com/",
  },
  {
    id: 9,
    name: "Rumo",
    description:
      "Operadora logística com foco em ferrovias, terminais e portos, integrando o escoamento da produção em larga escala.",
    imageUrl: "/Rumo.png",
    link: "https://www.rumolog.com/",
  },
  {
    id: 10,
    name: "Consórcio Minas Mais",
    description:
      "Consórcio ligado a projetos de mineração e infraestrutura, com participação da Gerdau em empreendimentos estratégicos.",
    imageUrl: "/MINASMAIS.jpeg",
    link: "https://www.instagram.com/consorciominasgerais/",
  },
  {
    id: 11,
    name: "Gerdau",
    description:
      "Uma das maiores produtoras de aço das Américas, com forte presença em construção civil, indústria e infraestrutura.",
    imageUrl: "/gerdau.png",
    link: "https://www2.gerdau.com/",
  },
];

// Fake API: grupos / clientes finais
export function fetchFinalClientsData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar grupos/segmentos em que já atuamos");
      } else {
        resolve(finalClientsData);
      }
    }, 400);
  });
}


// Fake API: lista de empresas / experiência profissional
export function fetchServicesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar experiência em empresas");
      } else {
        resolve(servicesData);
      }
    }, 400);
  });
}


// ==============================
// Sobre - Dados da empresa (usados em várias seções)
// ==============================
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
  whatsappNumber: "5531988884422",
};


// Fake API: dados principais da empresa (Hero, Contato, etc.)
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


// ==============================
// Header - Menu principal
// ==============================
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


// ==============================
// Portfólio - Entregáveis (Anexos, documentos técnicos)
// ==============================
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
  }
];


// Fake API: entregáveis (usados na seção Portfólio)
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


// Fake API: tipos de obras (usados como chips na seção Portfólio)
export function fetchServiceTypesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar tipos de obras");
      } else {
        resolve(serviceTypes);
      }
    }, 300);
  });
}


// ==============================
// Hero - Capa da página inicial (imagem de fundo e legenda)
// ==============================
export const heroCoverData = {
  imageUrl: "/aeroportoAfonsoPena.jpg",
  caption:
    "Aeroporto Internacional Afonso Pena – participação do Eng. Fernando Guimarães Costa Pinto em serviços de engenharia em empreendimento da Andrade Gutierrez (1994), experiência que hoje compõe o histórico técnico da Costa Pinto Engenharia LTDA.",
};


// Fake API: dados da capa (Hero)
export function fetchHeroCoverData() {
  return new Promise((resolve, reject) => {
    const success = true; // coloca false pra testar erro

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar capa (hero)");
      } else {
        resolve(heroCoverData);
      }
    }, 300);
  });
}


// ==============================
// Sobre - Princípios / textos conceituais da empresa
// ==============================
export const aboutHighlights = {
  whoWeAre:
    "Empresa dedicada à elaboração de propostas técnicas, planejamento e apoio em engenharia civil, com foco em obras de infraestrutura, saneamento, mineração e empreendimentos de grande porte.",

  whatWeBelieve:
    "Acreditamos que uma proposta técnica bem estruturada é a base para uma obra segura, eficiente e com boa previsibilidade de custos e prazos.",

  partnershipFocus:
    "Buscamos parcerias em que possamos somar experiência técnica, organização e confiabilidade aos projetos de nossos clientes.",
};


// ==============================
// Sobre - Pilares de atuação (valores / forma de trabalho)
// ==============================
export const aboutPillars = [
  {
    id: 1,
    title: "Compromisso com o resultado",
    text: "Propostas técnicas alinhadas ao escopo, prazos e critérios de contratação definidos em edital ou termo de referência.",
  },
  {
    id: 2,
    title: "Responsabilidade e segurança",
    text: "Atenção constante às premissas de segurança, meio ambiente e qualidade, respeitando normas e boas práticas de engenharia.",
  },
  {
    id: 3,
    title: "Clareza técnica",
    text: "Documentos objetivos, com premissas, metodologias e critérios de medição claramente descritos para facilitar a análise do contratante.",
  },
  {
    id: 4,
    title: "Parceria de longo prazo",
    text: "Atuação próxima ao cliente, revisando e ajustando estudos e documentos conforme a necessidade de cada empreendimento.",
  },
];


// ==============================
// Sobre - Fake API (combina dados cadastrais + princípios + pilares)
// ==============================
export function fetchAboutData() {
  return new Promise((resolve, reject) => {
    const success = true; // coloca false se quiser testar erro

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar dados da seção Sobre");
      } else {
        resolve({
          enterprise: enterpriseData,
          highlights: aboutHighlights,
          pillars: aboutPillars,
        });
      }
    }, 350);
  });
}


// ==============================
// Sobre - Foto em destaque (imagem com autoridade / obra)
// ==============================
export const aboutPhotoHighlight = {
  imageUrl: "/ImagemComAlguem.png",
  alt: "Registro do Eng. Fernando Guimarães Costa Pinto com o governador Romeu Zema em visita às obras do metrô de Belo Horizonte em 2024",
  caption:
    "Registro do Eng. Fernando Guimarães Costa Pinto ao lado do governador Romeu Zema, em visita às obras do metrô de Belo Horizonte (2024), ilustrando a experiência profissional que hoje dá suporte às atividades da Costa Pinto Engenharia LTDA.",
};


// Fake API: foto de destaque usada na seção Sobre
export function fetchAboutPhotoHighlight() {
  return new Promise((resolve, reject) => {
    const success = true; // coloca false se quiser testar erro

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar foto de destaque da seção Sobre");
      } else {
        resolve(aboutPhotoHighlight);
      }
    }, 300);
  });
}
