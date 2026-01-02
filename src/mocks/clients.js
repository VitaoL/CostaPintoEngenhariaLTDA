export const finalClientsData = [
  {
    id: 1,
    name: "Grupo de Mineração Regional",
    description:
      "Propostas técnicas para obras de infraestrutura, acessos e apoio em mineração.",
    imageUrl: "/VALE.png",
    link: "",
  },
  {
    id: 2,
    name: "Concessionária de Rodovias",
    description:
      "Elaboração de propostas para manutenção, duplicação e segurança viária.",
    imageUrl: "/motiva.png",
    link: "",
  },
  {
    id: 3,
    name: "Indústria de Alumínio e Metais",
    description:
      "Documentação técnica para prestação de serviços em áreas industriais.",
    imageUrl: "/albras.jpeg",
    link: "",
  },
  {
    id: 4,
    name: "Empresa de Energia e Saneamento",
    description:
      "Propostas para obras de saneamento, redes e melhorias operacionais.",
    imageUrl: "/anglo.jpeg",
    link: "",
  },
  {
    id: 5,
    name: "Grupo de Engenharia e Consultoria",
    description:
      "Parcerias em propostas de projetos, consultorias e gerenciamento de obras.",
    imageUrl: "/CONCREMAT.png",
    link: "",
  },
  {
    id: 6,
    name: "Complexo Siderúrgico",
    description:
      "Propostas de apoio técnico para ampliações e manutenção industrial.",
    imageUrl: "/CSN.png",
    link: "",
  },
  {
    id: 7,
    name: "Operadora Logística",
    description:
      "Estudos e propostas para obras ferroviárias, terminais e acessos.",
    imageUrl: "/Rumo.png",
    link: "",
  },
  {
    id: 8,
    name: "Consórcio de Infraestrutura",
    description:
      "Propostas elaboradas para obras de grande porte com foco em prazos e custos.",
    imageUrl: "/MINASMAIS.jpeg",
    link: "",
  },
];

export function fetchFinalClientsData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar clientes finais");
      } else {
        resolve(finalClientsData);
      }
    }, 400);
  });
}
