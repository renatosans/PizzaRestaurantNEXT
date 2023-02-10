import { prisma } from '../utils/connection'
import { pizzaType, ingredientType } from "../utils/types"
import { all, allIngredients } from '../utils/fakeData';


// run the command on terminal to populate data
// >  prisma db seed

async function main() {

    await prisma.pizza.createMany({ data: all })

    // run INSERT_ingredients.sql  for this data
    // await prisma.ingredients.createMany({ data: allIngredients })
}

main()
.catch(async (e) => {
    console.error(e);
    process.exit(1);
})
.finally(async () => {
    await prisma.$disconnect();
})
