import { PrismaClient } from '@prisma/client';


const host     = 'localhost'
const port     = 27017
const database = 'pizza_ordering'
const ssl      = false
const setSSL   = 'sslaccept=strict&sslmode=require'


// DATABASE_URL="mongodb://localhost:27017/pizza_ordering"
let url = `mongodb://${host}:${port}/${database}`;
if (ssl) {
    url = url + `?${setSSL}`;
}

const prisma = new PrismaClient({datasources: { db: { url: url } } })

export { prisma }
