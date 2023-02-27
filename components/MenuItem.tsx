import React, {useContext} from 'react'
import Image from 'next/image'
import styles from '../styles/MenuItem.module.scss'

import AppContext from '../AppContext';
import { pizzaType } from '../utils/types';
import {priceAfterDiscount} from '../utils/helpers';
import Router from 'next/router';

interface IMenuItem {
    pizza: pizzaType
}

const HeatIcon = () => {
    return (
        <div className={styles.pizza_heat_icon}>
            <Image src='/img/pepper.png' alt='pepper' width={24} height={24} />
        </div>
    )
}

export const HeatLevel = (props: any) => {
    const peppers = (level: number) => {
        const count = (level > 5) ? 5 : level;
        const pepperArr = new Array(count);

        return pepperArr;
    }
    return (
        <>{
            Array.from(peppers(props.level), (el: any, index: number) => <HeatIcon key={index} />)
        }
        </>
    )
}

const MenuItem:React.FC<IMenuItem> = ({pizza}) => {

    const context = useContext(AppContext);

    const addToCart = context.update.addToCart;

    const openInfo = () => {
        Router.push(        {
            pathname: '/pizza-info',
            query: {name:pizza.name},
        })
    }

    return (
        <a onClick={() => openInfo()}  className={styles.pizza_panel}>{
                pizza.discount &&
                    <div className={styles.pizza_discount}>{pizza.discount}%</div>
            }
            <div className={styles.pizza_image}>
                <Image src={pizza.imageSrc} alt={pizza.name} layout="fill" objectFit='cover' />
            </div>
            <div className={styles.pizza_info}>
                <div className={styles.pizza_row}>
                    <h2>{pizza.name}</h2>{
                        pizza.discount
                        ? <div className={styles.pizza_row}><h3 className={styles.pizza_price_dc}>{pizza.price}{pizza.currency}</h3> <h3>{priceAfterDiscount(pizza.price,pizza.discount)}{pizza.currency}</h3></div>
                        : <h3>{pizza.price} {pizza.currency}</h3>
                    }
                </div>
                <div className={styles.pizza_row}>
                    <div className={styles.pizza_row}>
                        <HeatLevel level={pizza.heat}></HeatLevel>
                    </div>
                    <button className={styles.pizza_add} onClick={(e) => {
                        e.stopPropagation();
                        addToCart(pizza);
                        }}>
                        Add to Cart
                    </button>
                </div>
            </div>
        </a>
    )
}

export default MenuItem
