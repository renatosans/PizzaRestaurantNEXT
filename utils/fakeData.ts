import { ingredientType, menuOptionType, pizzaType } from "./types"

const lorem = 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.'

  export const cheapest:pizzaType[] = [
    {
      name: 'Neapolitan Pizza',
      imageSrc: '/palermo.jpg',
      heat: 3,
      price: 15,
      currency: '$',
      description:lorem
    },
    {
      name: 'California Pizza',
      imageSrc: '/pizza6.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description:lorem
    },
    {
      name: 'New York-Style Pizza',
      imageSrc: '/pizza7.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description:lorem
    },
    {
      name: 'Volcano',
      imageSrc: '/pizza8.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description:lorem
    },
  ]

  export const trending:pizzaType[] = [
    {
      name: 'Sicilian Pizza',
      imageSrc: '/pizza1.jpg',
      heat: 3,
      price: 15,
      currency: '$',
      description:lorem
    },
    {
      name: 'Havaian',
      imageSrc: '/pizza2.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description:lorem
    },
    {
      name: 'Detroit Pizza',
      imageSrc: '/palermo2.jpg',
      heat: 1,
      price: 25,
      discount: -10,
      currency: '$',
      description:lorem
    },
  ]

  export const best:pizzaType[] = [
    {
      name: 'Chicago Pizza',
      imageSrc: '/pizza3.jpg',
      heat: 3,
      price: 15,
      currency: '$',
      description:lorem
    },
    {
      name: 'Greek Pizza',
      imageSrc: '/pizza4.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description:lorem
    },
    {
      name: 'Types of Pizza Crust',
      imageSrc: '/pizza5.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description:lorem
    },
  ]

  export const allIngredients: ingredientType[] = [
    {
      "id" : 1,
      "name" : "Calabresa",
      "flag" : true,
      "img" : "https://img.freepik.com/free-photo/fresh-raw-sausage-old-wooden_2829-15934.jpg"
    },
    {
      "id" : 2,
      "name" : "Ovo",
      "flag" : true,
      "img" : "https://img.freepik.com/free-photo/top-view-duck-eggs-dark-surface_1150-36985.jpg"
    },
    {
      "id" : 3,
      "name" : "Tomate",
      "flag" : true,
      "img" : "https://img.freepik.com/free-photo/fresh-tomatoes-ready-cook_1150-38243.jpg"
    },
    {
      "id" : 4,
      "name" : "Mussarela",
      "flag" : true,
      "img" : "https://img.freepik.com/free-photo/isometric-cheese-composition_23-2148161904.jpg"
    },
    {
      "id" : 5,
      "name" : "Azeitona",
      "flag" : true,
      "img" : "https://img.freepik.com/free-photo/fresh-tasty-green-olives_1220-1414.jpg"
    },
    {
      "id" : 6,
      "name" : "Peperoni",
      "flag" : true,
      "img" : "https://img.freepik.com/free-photo/tasty-traditional-chorizo-assortment_23-2148980296.jpg"
    },
    {
      "id" : 7,
      "name" : "Presunto",
      "flag" : true,
      "img" : "https://img.freepik.com/free-photo/pork-ham_1339-2076.jpg"
    },
  ]

  export const menuOptions:menuOptionType[] = [
    {
      name: 'Home',
      sections: [
        {
          name: 'Best',
          list: best
        },
        {
          name: 'Trending',
          list: trending
        },
        {
          name: 'Cheapest',
          list: cheapest
        }
      ] 
    },
    {
      name: 'Vegan',
      sections: [
        {
          name: 'Fully vegan',
          list: cheapest
        },
        {
          name: 'No meat',
          list: cheapest
        }
      ] 
    },
    {
      name: 'Cheezy',
      sections: [
        {
          name: 'Parmesan',
          list: cheapest
        },
        {
          name: 'Mix',
          list: cheapest
        }
      ] 
    },
  ]


export const all = trending.concat(best,cheapest);  // isso tá estranho, cade o field pizza_type (cheapest, best, trending)
