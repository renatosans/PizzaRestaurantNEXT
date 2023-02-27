import fs from 'fs'
import path from 'path'
import { prisma } from '../../../utils/connection'
import { ingredientType } from '../../../utils/types'
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

// TODO : >>   Fix image upload    <<
// Open INSOMNIA to test the endpoint ( http://localhost:3000/api/ingredients ),  use   sampleData.json
// Expected behaviour : write the image to File System and store the image relative path in the database
const saveIngredient = async (req: NextApiRequest, res: NextApiResponse) => {
	const { ingredient_id, ingredient_name, flag, supplier, imageFormat, imageData } = req.body;

	const nextNumber = Math.round(Math.random() * 99999);
	const timeStampSalt = `NaN${Date.now()}`;
	const dir = '/img/ingredients/';
	const filename = `ingredient_${timeStampSalt}_${nextNumber.toString()}.jpg`;
	const buffer = Buffer.from(imageData, 'base64');
	const filePath: fs.PathLike = path.resolve(`./public${dir}`, filename);
	console.log(`FilePath is ${filePath}`);
	fs.open(filePath, "w", (err, fd) => {
		fs.write(fd, buffer, 0, buffer.length, (err, writtenBytes, buffer) => {
			console.log(`Wrote ${writtenBytes} bytes to file`);
		});
	});

	const img: string = dir + filename;
	const newIngredient: ingredientType = { ingredient_id, ingredient_name, flag, img, supplier };

    prisma.ingredients.create({ data: newIngredient })
    .then((result) => res.send(result))
	.catch((error) => res.status(500).send("Error: " + error.message))
}

const getIngredients = async (req: NextApiRequest, res: NextApiResponse) => {
    prisma.ingredients.findMany()
    .then((ingredients) => res.send(ingredients))
    .catch((error) => res.status(500).send("Error: " + error.message))
}
