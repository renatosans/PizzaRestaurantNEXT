import React from 'react'
import styles from '../styles/Home.module.scss'


type props = {
  sentence1: string;
  sentence2: string;
  sentence3: string;
}

const Slogan = ({sentence1, sentence2, sentence3, children}: React.PropsWithChildren<props>) => {
    return (
        <div className={styles.hero_text}>
            <div className={styles.txt}>
                <h1>{sentence1}</h1>
                <h1>{sentence2}</h1>
                <h1>{sentence3}</h1>
            </div>
            <div className={styles.hero_lines}>
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    )
}

export default Slogan
