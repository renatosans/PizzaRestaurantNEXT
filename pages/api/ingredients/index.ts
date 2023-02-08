import { prisma } from '../../../utils/connection'
import type { NextApiRequest, NextApiResponse } from 'next'


export default async function handler(req: NextApiRequest, res: NextApiResponse) {
	switch (req.method) {
		case "POST": {
			return saveIngredient(req, res);
		}
		case "GET": {
			return getIngredients(req, res);
		}
	}
}

const saveIngredient = async (req: NextApiRequest, res: NextApiResponse) => {
    prisma.ingredients.create({ data: req.body })
    .then((result) => res.send(result))
	.catch((error) => res.send("Error: " + error.message))
}

const getIngredients = async (req: NextApiRequest, res: NextApiResponse) => {
    prisma.ingredients.findMany()
    .then((ingredients) => res.send(ingredients))
    .catch((error) => res.send("Error: " + error.message))
}
