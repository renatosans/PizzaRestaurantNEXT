import React from 'react'
import Image from 'next/image'
import styles from '../styles/Home.module.scss'


type props = {
  title: string;
  offerings: string;  
}


const Banner = ({title, offerings, children}: React.PropsWithChildren<props>) => {
    return (
    <>
      <div className={styles.ad}>
        <div className={styles.ad_column}>
          <h2>{title}</h2>
          <p>
            We believe that every restaurant has its heart and it’s the kitchen.
            La Cucina means kitchen in Italian and in our restaurant & pizzeria it is open for every guest.
            The way food is prepared and made is important. What if you could actually see how your dish is
            created by our chefs? You can see it! We have an open kitchen which means all the action is there
            and you can enjoy it when sitting on your table.<br/><br/>
            {offerings}<br/><br/>
            Do we have pizzas? Of course we do! Actually we have really special ones, which are called
            Neapolitan style pizzas. Come and try!
          </p>
        </div> 
        <div className={styles.ad_column}>
          <Image src='/img/pizzeria.jpg' alt='ad' layout="fill" objectFit='cover' />
        </div>
      </div>
    </>
    )
}

export default Banner
