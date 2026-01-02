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
