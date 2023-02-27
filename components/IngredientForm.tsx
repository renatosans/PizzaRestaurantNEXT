import styles from '../styles/Ingredient.module.scss'  
import { notification } from '../utils/notification'
import { useState, useEffect, FormEvent, ChangeEvent } from 'react'
import toast, { Toaster, ToastOptions } from 'react-hot-toast'


export const IngredientForm = ({dialogRef}: any) => {

	const [ingredient, setIngredient] = useState({
        ingredient_name: "",
		flag: false,
		supplier: "",
	})

    const [image, setImage] = useState({
        imageFormat: "",
        imageData: "",
    });

    const handleSubmit = async (e: FormEvent) => {
		e.preventDefault();

		if (ingredient.ingredient_name === "" || ingredient.supplier === "") {
			toast.error('Favor preencher todos os campos!', notification.options as ToastOptions);
			return;
		}

        try {
            const payload = {...ingredient, ...image};

            await fetch(`/api/ingredients`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', },
                body: JSON.stringify(payload),
            })
        } catch (error: any) {
			toast.error(error.message, notification.options as ToastOptions);
			return;
        }

		toast.success('Ingrediente salvo com sucesso', notification.options as ToastOptions);
		dialogRef.toggle();
    }

	const onChange = (e: any) => {
		if (e.target.type === 'file') {
			const file = e.target.files[0];
			// Reads the file using the FileReader API
			const reader = new FileReader();
			reader.onloadend = () => {
				const fileData = reader.result.split(';base64,');
				let formato = fileData[0].replace('data:', '') + ';base64';
                setImage({imageFormat: formato, imageData: fileData[1]});
			}
			reader.readAsDataURL(file);
		}

        setIngredient({...ingredient, [e.target.name]: e.target.value, });
	};

    return (
    <>
        <Toaster />
        <form onSubmit={handleSubmit} className={styles.form} >
            <label htmlFor="ingredient_name" className={styles.label} >Ingrediente</label>
            <input type="text" className={styles.input} name="ingredient_name" value={ingredient.ingredient_name} onChange={onChange} />
            <label htmlFor="supplier" className={styles.label} >Fornecedor</label>
            <input type="text" className={styles.input} name="supplier" value={ingredient.supplier} onChange={onChange} />

            <label htmlFor="foto" className={styles.label} >Foto</label>
            <div className={styles.fileDialog}>
                <input type="file" name="foto" accept=".gif,.jpg,.jpeg,.png" onChange={onChange} />
                <img style={{'width':'100%'}} src={"data:" + image.imageFormat + ", " + image.imageData} alt={ingredient.ingredient_name}></img>
            </div>

            <button type="submit" className={styles.button}>Salvar</button>
        </form>
    </>
    )
}

export default IngredientForm;
