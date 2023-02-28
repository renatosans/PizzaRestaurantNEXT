import { ingredientType, menuOptionType, pizzaType } from "./types"


  export const cheapest:pizzaType[] = [
    {
      name: 'Neapolitan Pizza',
      imageSrc: '/img/pizzas/palermo.jpg',
      heat: 3,
      price: 15,
      currency: '$',
      description: 'A basic dough, raw tomatoes, fresh mozzarella cheese, fresh basil, and olive oil',
    },
    {
      name: 'California Pizza',
      imageSrc: '/img/pizzas/pizza6.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description: 'Chicken, peanut sauce, artichoke hearts, and goat cheese',
    },
    {
      name: 'New York-Style Pizza',
      imageSrc: '/img/pizzas/pizza7.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description: 'Pizza dough, tomato sauce, mozzarella',
    },
    {
      name: 'Volcano',
      imageSrc: '/img/pizzas/pizza8.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description: 'BBQ sauce, chicken, pineapple, green peppers, onions, jalapenos, and mozzarella',
    },
  ]

  export const trending:pizzaType[] = [
    {
      name: 'Sicilian Pizza',
      imageSrc: '/img/pizzas/pizza1.jpg',
      heat: 3,
      price: 15,
      currency: '$',
      description: 'Pecorino, pepperoni, and sliced mozzarella cheese',
    },
    {
      name: 'Havaian',
      imageSrc: '/img/pizzas/pizza2.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description: 'Pineapple, tomato sauce, cheese, ham or bacon',
    },
    {
      name: 'Detroit Pizza',
      imageSrc: '/img/pizzas/palermo2.jpg',
      heat: 1,
      price: 25,
      discount: -10,
      currency: '$',
      description: 'Chewy crust, pizza sauce, melty cheese galore and pepperoni cups',
    },
  ]

  export const best:pizzaType[] = [
    {
      name: 'Chicago Pizza',
      imageSrc: '/img/pizzas/pizza3.jpg',
      heat: 3,
      price: 15,
      currency: '$',
      description: 'Pizza dough, tomato sauce, cheese, sausage, pepperoni, onions and mushrooms',
    },
    {
      name: 'Greek Pizza',
      imageSrc: '/img/pizzas/pizza4.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description: 'Pizza dough, cheese, tomato sauce, feta, spinach and olives',
    },
    {
      name: 'Types of Pizza Crust',
      imageSrc: '/img/pizzas/pizza5.jpg',
      heat: 2,
      price: 9,
      currency: '$',
      description: "Choose 5 ingredients from our menu"
    },
  ]

  export const allIngredients: ingredientType[] = [
    {
      "ingredient_id" : 1,
      "ingredient_name" : "Calabresa",
      "flag" : true,
      "img" : "/img/ingredients/ingredient1.jpg",
      "supplier": "Assaí Atacadista",
    },
    {
      "ingredient_id" : 2,
      "ingredient_name" : "Ovo",
      "flag" : true,
      "img" : "/img/ingredients/ingredient2.jpg",
      "supplier": "Extra",
    },
    {
      "ingredient_id" : 3,
      "ingredient_name" : "Tomate",
      "flag" : true,
      "img" : "/img/ingredients/ingredient3.jpg",
      "supplier": "Mercadão Atacadista",
    },
    {
      "ingredient_id" : 4,
      "ingredient_name" : "Mussarela",
      "flag" : false,
      "img" : "/img/ingredients/ingredient4.jpg",
      "supplier": "Extra",
    },
    {
      "ingredient_id" : 5,
      "ingredient_name" : "Azeitona",
      "flag" : true,
      "img" : "/img/ingredients/ingredient5.jpg",
      "supplier": "Mercadão Atacadista",
    },
    {
      "ingredient_id" : 6,
      "ingredient_name" : "Peperoni",
      "flag" : false,
      "img" : "/img/ingredients/ingredient6.jpg",
      "supplier": "Assaí Atacadista",
    },
    {
      "ingredient_id" : 7,
      "ingredient_name" : "Queijo Gorgonzola",
      "flag" : false,
      "img" : "/img/ingredients/ingredient7.jpg",
      "supplier" : "Carrefour",
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
