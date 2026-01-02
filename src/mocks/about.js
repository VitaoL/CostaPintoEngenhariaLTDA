import { enterpriseData } from "./enterprise";

export const aboutHighlights = {
  whoWeAre:
    "Somos uma empresa familiar de engenharia civil que está começando sua trajetória, com foco em propostas técnicas e apoio à execução de obras.",
  whatWeBelieve:
    "Acreditamos que uma proposta bem-feita nasce do diálogo, da organização e do cuidado em traduzir o escopo com clareza.",
  partnershipFocus:
    "Buscamos parcerias em que possamos somar confiança, agilidade e atenção aos detalhes que fazem a diferença.",
};

export const aboutPillars = [
  {
    id: 1,
    title: "Propostas com começo, meio e fim",
    text: "Estruturamos escopo, metodologia e critérios de medição para facilitar a análise do contratante.",
  },
  {
    id: 2,
    title: "Responsabilidade técnica",
    text: "Cuidamos de segurança, qualidade e conformidade com normas e boas práticas.",
  },
  {
    id: 3,
    title: "Comunicação humana e direta",
    text: "Explicamos cada etapa de forma clara, com abertura para ajustes.",
  },
  {
    id: 4,
    title: "Parceria próxima",
    text: "Acompanhamos o cliente do estudo inicial ao fechamento da proposta.",
  },
];

export const serviceAudienceData = [
  {
    id: 1,
    title: "Construtoras e consórcios",
    text: "Apoiamos equipes que precisam organizar a proposta técnica para licitações e contratos.",
  },
  {
    id: 2,
    title: "Empresas de infraestrutura",
    text: "Atendemos demandas de rodovias, saneamento, logística e obras urbanas.",
  },
  {
    id: 3,
    title: "Setor industrial e mineração",
    text: "Preparamos documentação para obras, ampliações e serviços especializados.",
  },
];

export const aboutPhotoHighlight = {
  imageUrl: "/ImagemComAlguem.png",
  alt: "Registro do Eng. Fernando Guimarães Costa Pinto em visita técnica",
  caption:
    "Visita técnica em obra de infraestrutura, refletindo a experiência que orienta cada proposta da Costa Pinto Engenharia.",
};

export function fetchAboutData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar dados da seção Sobre");
      } else {
        resolve({
          enterprise: enterpriseData,
          highlights: aboutHighlights,
          pillars: aboutPillars,
          audience: serviceAudienceData,
        });
      }
    }, 350);
  });
}

export function fetchAboutPhotoHighlight() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar foto de destaque da seção Sobre");
      } else {
        resolve(aboutPhotoHighlight);
      }
    }, 300);
  });
}
