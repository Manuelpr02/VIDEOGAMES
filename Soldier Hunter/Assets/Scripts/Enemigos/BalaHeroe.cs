using UnityEngine;

public partial class BalaHeroe : MonoBehaviour
{
    [Header("Configuración")]
    public float velocidad = 10f;
    public float daño = 1f;
    public float tiempoVida = 3f; // Segundos antes de desaparecer sola

    private Vector2 direccion;

    void Start()
    {
        // Determinar dirección basada en la escala del héroe al nacer
        // Si el héroe escala X es negativa, dispara a la izquierda
        GameObject heroe = GameObject.Find("Heroe"); // Asegúrate de que el nombre coincida
        if (heroe != null && heroe.transform.localScale.x < 0)
        {
            direccion = Vector2.left;
        }
        else
        {
            direccion = Vector2.right;
        }

        // Destruir automáticamente después de unos segundos
        Destroy(gameObject, tiempoVida);
    }

    void Update()
    {
        // Movimiento constante
        transform.Translate(direccion * velocidad * Time.deltaTime);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        // Si choca con el Personaje (el villano)
        if (collision.CompareTag("Player"))
        {
            collision.GetComponent<MovimientoEnemigo>().TomarDanio(1);

            Debug.Log("¡El héroe te ha dado!");
            Destroy(gameObject);
        }

        // Si choca con el suelo o paredes
        if (collision.gameObject.layer == LayerMask.NameToLayer("Suelo"))
        {
            Destroy(gameObject);
        }
    }
}