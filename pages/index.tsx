import styles from '../styles/Home.module.scss'
import Router from 'next/router'
import type { NextPage } from 'next'
import Draggable from 'react-draggable'
import { Button, Dialog } from '@mui/material'
import React, {useRef, useState} from 'react'
import {menuOptions} from '../utils/fakeData'
import { menuOptionType } from '../utils/types'
import Banner from '../components/Banner'
import MenuSection from '../components/MenuSection'
import { IngredientForm } from '../components/IngredientForm'


const Home: NextPage = () => {
    const menu_ref = useRef(null);
    const [open, setOpen] = useState(true);
    const [currentMenuOption,setCurrentMenuOption] = useState(menuOptions[0]);

    const changeMenuOption = (option:menuOptionType) => {
      if(currentMenuOption === option) return;
      setCurrentMenuOption(option);
    }

    const scrollIntoView = (ref: React.RefObject<HTMLDivElement>) => {
      if(ref.current) ref.current.scrollIntoView();
    }

    const toggle = () => {
      setOpen(current => !current);
    }
  
  return (
    <div className={styles.homepage}>
			<Draggable>
        <Dialog open={open} onClose={toggle} BackdropProps={{ style: { backgroundColor: "transparent" } }} >
          <IngredientForm dialogRef={{ toggle }} />
        </Dialog>
			</Draggable>

      <div className={styles.hero}>
        <video preload="auto" autoPlay loop muted><source src='/video.mp4' type="video/mp4"/></video>
        <div className={styles.hero_text}>
          <div className={styles.txt}>
            <h1>Made</h1>
            <h1>with</h1>
            <h1>Love</h1>
          </div>
          <div className={styles.hero_lines}>
            <span></span>
            <span></span>
            <span></span>
          </div>
          <button className={styles.checkout_menu} onClick={() => scrollIntoView(menu_ref)}>
            <h3>Checkout Menu</h3>
          </button>
        </div>
      </div>
      <div ref={menu_ref} className={styles.menu}>
        <div className={styles.menu_options}>
          {menuOptions.map((option,index) => (
            <button className={`${currentMenuOption == option && styles.active}`} onClick={() => changeMenuOption(option)} key={index}>{option.name}</button>
          ))}
        </div>
        {currentMenuOption.sections.map((section,index) => (
          <MenuSection topic={section.name} list={section.list} key={index}/>
        ))}
        <button className={styles.all_button} onClick={() => Router.push('/all-pizzas')}>See all pizzas</button>
      </div>
      <Banner title='La Cucina' offerings='🍔 Hamburger 🍕 Pizza 🥪 Sandwich'>
        Our menu is versatile. You have fantastic meat dishes, salads and pastas.
      </Banner>
    </div>
  )
}

export default Home
