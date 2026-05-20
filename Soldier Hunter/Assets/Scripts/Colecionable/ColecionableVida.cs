using UnityEngine;

public class ColeccionableVida : MonoBehaviour
{
    [Header("Configuración")]
    public int cantidadCura = 1; // Cuánta vida da al recogerlo

    private void OnTriggerEnter2D(Collider2D collision)
    {
        // Verificamos si lo que tocó el coleccionable es el Jugador
        if (collision.CompareTag("Player"))
        {
            // Intentamos obtener el script del jugador
            MovimientoEnemigo jugador = collision.GetComponent<MovimientoEnemigo>();

            if (jugador != null)
            {
                // Llamamos a una función para curar (la crearemos ahora)
                jugador.Curar(cantidadCura);

                // Destruimos el objeto para que no se pueda coger dos veces
                Destroy(gameObject);
            }
        }
    }

    void Update()
    {
        // Hace que el objeto flote de arriba a abajo
        float nuevaY = Mathf.Sin(Time.time * 3f) * 0.1f;
        transform.position += new Vector3(0, nuevaY * Time.deltaTime, 0);
    }
}