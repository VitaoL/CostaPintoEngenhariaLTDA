import { enterpriseData } from "./enterprise";

export const aboutHighlights = {
  whoWeAre:
    "Atuamos em engenharia civil com foco em propostas técnicas bem estruturadas, planejamento e apoio à execução, garantindo clareza, conformidade e segurança em cada entrega.",
  whatWeBelieve:
    "Acreditamos que qualidade se constrói com método: levantamento correto, critérios bem definidos, documentação consistente e comunicação objetiva com todas as partes envolvidas.",
  partnershipFocus:
    "Trabalhamos como extensão da equipe do cliente, oferecendo agilidade com responsabilidade, padronização de entregas e atenção técnica aos pontos críticos do projeto.",
};

export const aboutPillars = [
  {
    id: 1,
    title: "Propostas técnicas robustas",
    text: "Organizamos escopo, metodologia, premissas, critérios de medição e entregáveis para facilitar análise, comparação e contratação.",
  },
  {
    id: 2,
    title: "Responsabilidade e conformidade",
    text: "Priorizamos segurança, qualidade e aderência às normas aplicáveis, com documentação clara e decisões técnicas justificadas.",
  },
  {
    id: 3,
    title: "Controle, prazos e previsibilidade",
    text: "Trabalhamos com planejamento e acompanhamento para reduzir retrabalho, minimizar riscos e apoiar o avanço da obra com previsibilidade.",
  },
  {
    id: 4,
    title: "Comunicação objetiva e transparente",
    text: "Alinhamos expectativas, registramos definições e mantemos o cliente informado, com abertura para ajustes e evolução do projeto.",
  },
];

export const serviceAudienceData = [
  {
    id: 1,
    title: "Construtoras e consórcios",
    text: "Apoiamos a estruturação de propostas técnicas, memoriais e documentação para licitações, contratos e execução, com clareza e padronização.",
  },
  {
    id: 2,
    title: "Empresas de infraestrutura",
    text: "Atendemos demandas de saneamento, mobilidade, logística e obras urbanas, com foco em planejamento, conformidade e qualidade técnica.",
  },
  {
    id: 3,
    title: "Indústria e mineração",
    text: "Preparamos documentação técnica e apoio à execução para adequações, ampliações e serviços especializados, com gestão de riscos e segurança.",
  },
];

export const aboutPhotoHighlight = {
  imageUrl: "/ImagemComAlguem.png",
  alt: "Eng. Fernando Guimarães Costa Pinto em visita técnica",
  caption:
    "Visita técnica e acompanhamento em campo: responsabilidade, método e atenção aos detalhes que impactam prazo, custo e qualidade.",
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
