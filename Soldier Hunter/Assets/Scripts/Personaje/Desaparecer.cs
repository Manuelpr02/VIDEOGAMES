using UnityEngine;
using TMPro; // Necesario para TextMeshPro
using System.Collections;

public class Desaparecer : MonoBehaviour
{
    private TextMeshProUGUI texto;
    public float esperaAntesDeBorrar = 3f;
    public float duracionDesvanecimiento = 1f;

    void Start()
    {
        texto = GetComponentInChildren<TextMeshProUGUI>();
        if (texto != null)
        {
            StartCoroutine(FadeOut());
        }
    }

    IEnumerator FadeOut()
    {
        // Esperamos los primeros segundos
        yield return new WaitForSeconds(esperaAntesDeBorrar);

        float tiempoPasado = 0;
        Color colorInicial = texto.color;

        while (tiempoPasado < duracionDesvanecimiento)
        {
            tiempoPasado += Time.deltaTime;
            // Calculamos la nueva transparencia
            float alpha = Mathf.Lerp(1, 0, tiempoPasado / duracionDesvanecimiento);
            texto.color = new Color(colorInicial.r, colorInicial.g, colorInicial.b, alpha);
            yield return null;
        }

        Destroy(gameObject);
    }
}