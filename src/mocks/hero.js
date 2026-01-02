export const heroCoverData = {
  images: ["/imagem1.png", "/imagem2.png", "/imagem3.png"],
  caption:
    "Apresentação de obras e estudos técnicos que refletem o cuidado em cada proposta.",
};

export function fetchHeroCoverData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar capa (hero)");
      } else {
        resolve(heroCoverData);
      }
    }, 300);
  });
}
