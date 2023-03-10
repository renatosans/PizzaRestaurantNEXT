import React,{ useEffect, useState } from 'react'
import MenuItem from '../components/MenuItem';

import styles from '../styles/AllPizzas.module.scss';
import { all, menuOptions } from '../utils/fakeData';
import { pizzaType } from '../utils/types';

import {ArrowDown, ArrowLeft, ArrowUp,LogOut} from 'react-feather';
import Router from 'next/router';
import { priceAfterDiscount } from '../utils/helpers';
import GoBack from '../components/GoBack';

interface IMenuButton {
    children:React.ReactNode,
    onClick: () => void,
    active: boolean,
}

enum Sort {
    PriceUp,
    PriceDown,
    Alphabet,
    Default
}

const MenuButton:React.FC<IMenuButton> = ({children, onClick, active}) => {
    return(
    <button className={`${styles.menu_button} ${active ? styles.active : ''}`} onClick={() => onClick()}>
        {children}
    </button>
    )
}

const AllPizzas = () => {

    const [pick, setPick] = useState<pizzaType[]>();
    const [pizzas, setPizzas] = useState<pizzaType[]>();


    const getPizzas = async () => {
        const response = await fetch(`/api/pizzas`);
        const allPizzas = await response.json();
    
        setPizzas(allPizzas);
    }

    useEffect(() => {
        getPizzas();
    }, []);

    const getAllCategories = () => {

        let categories:string[] = ['All'];

        menuOptions.map(option => {
            if(option.name !== 'Home')
                categories.push(option.name.toString());
        })

        return categories;
    }

    const categories = getAllCategories();
    const [currentSort,setCurrentSort] = useState(Sort.Default);
    const [currentCategory,setCurrentCategory] = useState('All');

    const sortList = (sort:Sort, array:pizzaType[] | undefined) => {
        switch (sort){
            case Sort.PriceUp:
                array = array?.sort((a,b) => {

                    let price1 = a.price;
                    let price2 = b.price;

                    if(a.discount){
                        price1 = priceAfterDiscount(a.price,a.discount);
                    }

                    if(b.discount){
                        price2 = priceAfterDiscount(b.price,b.discount);
                    }

                    if(price1 < price2) return -1;
                    if(price1 > price2) return 1;
                    
                    return 0;
                })
                break;

                case Sort.PriceDown:
                    array = array?.sort((a,b) => {
    
                        let price1 = a.price;
                        let price2 = b.price;
    
                        if(a.discount){
                            price1 = priceAfterDiscount(a.price,a.discount);
                        }
    
                        if(b.discount){
                            price2 = priceAfterDiscount(b.price,b.discount);
                        }
    
                        if(price1 > price2) return -1;
                        if(price1 < price2) return 1;
                        
                        return 0;
                    })
                    break;
                
                case Sort.Alphabet:
                    array = array?.sort((a,b) => { 
                        if(a.name.toLocaleLowerCase() < b.name.toLocaleLowerCase()) return -1;
                        if(a.name.toLocaleLowerCase() > b.name.toLocaleLowerCase()) return 1;
                        
                        return 0;
                    })
                    break;
        }

        return array;
    }

    const filterCategory = (category: string) => {
        let array:pizzaType[] = [];

        menuOptions.map(option => {
            if(option.name === category){
                option.sections.map(section => {
                    if(array !== undefined){
                        section.list.map(item => {
                            if(array.filter(e => e !== item)){
                                array.push(item);
                            }
                        })
                    }
                })
            }
        })

        return array;
    }

    const sortClick = (sort:any) => {
        let array: pizzaType[] | undefined;

        if(sort === Sort.Alphabet && currentSort === Sort.Alphabet){
            setCurrentSort(Sort.Default);
            array = (currentCategory === 'All') ? pizzas : filterCategory(currentCategory);
        }else{
            array = sortList(sort, pick);
            setCurrentSort(sort);
        }

        setPick(array);
    }

    const categoryClick = (category:string) => {
        setCurrentCategory(category);

        let array: pizzaType[] | undefined = (category === 'All') ? pizzas : filterCategory(category);
        array = sortList(currentSort, array);
        setPick(array);
    }

    const clearFilters = () => {
        setPick(pizzas);
        setCurrentCategory('All');
        setCurrentSort(Sort.Default);
    }

    return (
        <>
        <GoBack/>
        <div className={styles.container}>
            <div className={styles.menu}>
                <div className={styles.menu_buttons}>
                    {currentSort !== Sort.PriceDown
                    ?<MenuButton active={currentSort === Sort.PriceUp} onClick={() => sortClick(Sort.PriceDown)}>
                        Price
                        <ArrowUp strokeWidth={3} />
                    </MenuButton>
                    :<MenuButton active={currentSort === Sort.PriceDown} onClick={() => sortClick(Sort.PriceUp)}>
                        Price
                        <ArrowDown strokeWidth={3} />
                    </MenuButton>
                    }
                    <MenuButton active={currentSort === Sort.Alphabet} onClick={() => sortClick(Sort.Alphabet)}>
                        Alphabet
                    </MenuButton>
                    <div className={styles.choose_field}>
                        <label htmlFor="category">Category:</label>
                        <select name="category" id="category" value={currentCategory} onChange={(e) => categoryClick(categories[e.target.selectedIndex])}>
                            {categories.map((item,index) => (<option key={index} value={item}>{item}</option>))}
                        </select>
                    </div>
                    <MenuButton active={false} onClick={() => clearFilters()}>
                        Clear all Fiters
                    </MenuButton>
                </div>
            </div>
            <div className={styles.list}>{
                pizzas?.map((item, index) => <MenuItem pizza={item} key={index} />)
            }
            </div>
        </div>
        </>
    )
}

export default AllPizzas
