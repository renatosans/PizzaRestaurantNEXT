import { ingredientType } from '../utils/types'
import Head from 'next/head';
import React, { useState, useEffect, useContext } from 'react'
import Cart from './Cart';
import Footer from './Footer';
import Navbar from './Navbar'
import AppContext from '../AppContext';
import styles from '../styles/Layout.module.scss';
import { X } from 'react-feather';
import { toast, Toaster } from 'react-hot-toast';


interface ILayout {
    children: React.ReactNode,
}

const Layout:React.FC<ILayout> = ({children}) => {

    const [ingredients, setIngredients] = useState<ingredientType[]>();
    const [showCart,setShowCart] = useState(false);

    const context = useContext(AppContext);

    const closeNotification = context.update.closeNotification;
    const showNotification = context.state.showNotification

    const returnClick = () => {
        toast.success("Goback click");
    }

    const menuClick = () => {
        console.log(ingredients);
        toast.success("Menu click");
    }

    const cartClick = () => {
        setShowCart(!showCart);
    }

    const notificationClick = () => {
        closeNotification();
    }

    const getIngredients = async () => {
        const response = await fetch(`/api/ingredients`);
        const allIngredients = await response.json();

        setIngredients(allIngredients);
    }

    useEffect(() => {
        getIngredients();
    }, []);

    return (
        <>
        <Head>
            <title>Pizza House</title>
            <meta name="viewport" content="initial-scale=1.0, width=device-width" />
        </Head>
        <Toaster/>
        <Navbar returnClick={returnClick} menuClick={menuClick} cartClick={cartClick} showCart={showCart}/>
        <Cart show={showCart} />
        {<div className={`${styles.notification} ${showNotification && styles.notification_show}`}>
            <p>Item Added to Cart!</p>
            <button onClick={() => notificationClick()}>
                <X />
            </button>
        </div>}
            {children}
        <Footer />
        </>
    )
}

export default Layout
