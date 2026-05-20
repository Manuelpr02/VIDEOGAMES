using UnityEngine;

public class PlataformaMovil : MonoBehaviour
{
    [Header("Configuración de Movimiento")]
    public float velocidad = 3f;
    public float distanciaX = 5f; // Cuánto se mueve a la derecha desde el inicio
    public bool empezarDerecha = true;

    private Vector3 puntoA;
    private Vector3 puntoB;
    private Vector3 destinoActual;

    void Start()
    {
        // Definimos los puntos de ida y vuelta basados en la posición inicial
        puntoA = transform.position;
        puntoB = new Vector3(transform.position.x + distanciaX, transform.position.y, transform.position.z);

        destinoActual = empezarDerecha ? puntoB : puntoA;
    }

    void Update()
    {
        // Mover la plataforma
        transform.position = Vector3.MoveTowards(transform.position, destinoActual, velocidad * Time.deltaTime);

        // Si llega al destino, cambia al otro punto
        if (Vector3.Distance(transform.position, destinoActual) < 0.1f)
        {
            destinoActual = (destinoActual == puntoA) ? puntoB : puntoA;
        }
    }

    // --- LÓGICA PARA QUE EL PERSONAJE SE MUEVA CON LA PLATAFORMA ---

    private void OnCollisionEnter2D(Collision2D collision)
    {
        // Solo si el objeto que sube es el personaje y está encima (no pegado a los lados)
        if (collision.gameObject.CompareTag("Player"))
        {
            // Comprobar que el personaje está ARRIBA de la plataforma
            if (collision.contactCount > 0 && collision.GetContact(0).normal.y < -0.5f)
            {
                collision.transform.SetParent(transform);
            }
        }
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            collision.transform.SetParent(null);
        }
    }
}